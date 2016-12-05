import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;

public class FlippingBitsGame extends JPanel {
    final int maxLevel = 7;
    final int minLevel = 3;

    private Random rand = new Random();
    private int[][] grid, target;
    private Rectangle box;
    private int n = maxLevel;
    private boolean solved = true;

    FlippingBitsGame() {
        setPreferredSize(new Dimension(640, 640));
        setBackground(Color.white);
        setFont(new Font("SansSerif", Font.PLAIN, 18));

        box = new Rectangle(120, 90, 400, 400);

        startNewGame();

        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                if (solved) {
                    startNewGame();
                } else {
                    int x = e.getX();
                    int y = e.getY();

                    if (box.contains(x, y))
                        return;

                    if (x > box.x && x < box.x + box.width) {
                        flipCol((x - box.x) / (box.width / n));

                    } else if (y > box.y && y < box.y + box.height)
                        flipRow((y - box.y) / (box.height / n));

                    if (solved(grid, target))
                        solved = true;

                    printGrid(solved ? "Solved!" : "The board", grid);
                }
                repaint();
            }
        });
    }

    void startNewGame() {
        if (solved) {

            n = (n == maxLevel) ? minLevel : n + 1;

            grid = new int[n][n];
            target = new int[n][n];

            do {
                shuffle();

                for (int i = 0; i < n; i++)
                    target[i] = Arrays.copyOf(grid[i], n);

                shuffle();

            } while (solved(grid, target));

            solved = false;
            printGrid("The target", target);
            printGrid("The board", grid);
        }
    }

    void printGrid(String msg, int[][] g) {
        System.out.println(msg);
        for (int[] row : g)
            System.out.println(Arrays.toString(row));
        System.out.println();
    }

    boolean solved(int[][] a, int[][] b) {
        for (int i = 0; i < n; i++)
            if (!Arrays.equals(a[i], b[i]))
                return false;
        return true;
    }

    void shuffle() {
        for (int i = 0; i < n * n; i++) {
            if (rand.nextBoolean())
                flipRow(rand.nextInt(n));
            else
                flipCol(rand.nextInt(n));
        }
    }

    void flipRow(int r) {
        for (int c = 0; c < n; c++) {
            grid[r][c] ^= 1;
        }
    }

    void flipCol(int c) {
        for (int[] row : grid) {
            row[c] ^= 1;
        }
    }

    void drawGrid(Graphics2D g) {
        g.setColor(getForeground());

        if (solved)
            g.drawString("Solved! Click here to play again.", 180, 600);
        else
            g.drawString("Click next to a row or a column to flip.", 170, 600);

        int size = box.width / n;

        for (int r = 0; r < n; r++)
            for (int c = 0; c < n; c++) {
                g.setColor(grid[r][c] == 1 ? Color.blue : Color.orange);
                g.fillRect(box.x + c * size, box.y + r * size, size, size);
                g.setColor(getBackground());
                g.drawRect(box.x + c * size, box.y + r * size, size, size);
                g.setColor(target[r][c] == 1 ? Color.blue : Color.orange);
                g.fillRect(7 + box.x + c * size, 7 + box.y + r * size, 10, 10);
            }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        drawGrid(g);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Flipping Bits Game");
            f.setResizable(false);
            f.add(new FlippingBitsGame(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
