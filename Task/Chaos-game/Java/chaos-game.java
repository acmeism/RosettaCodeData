import java.awt.*;
import java.awt.event.*;
import java.util.*;
import javax.swing.*;
import javax.swing.Timer;

public class ChaosGame extends JPanel {
    static class ColoredPoint extends Point {
        int colorIndex;

        ColoredPoint(int x, int y, int idx) {
            super(x, y);
            colorIndex = idx;
        }
    }

    Stack<ColoredPoint> stack = new Stack<>();
    Point[] points = new Point[3];
    Color[] colors = {Color.red, Color.green, Color.blue};
    Random r = new Random();

    public ChaosGame() {
        Dimension dim = new Dimension(640, 640);
        setPreferredSize(dim);
        setBackground(Color.white);

        int margin = 60;
        int size = dim.width - 2 * margin;

        points[0] = new Point(dim.width / 2, margin);
        points[1] = new Point(margin, size);
        points[2] = new Point(margin + size, size);

        stack.push(new ColoredPoint(-1, -1, 0));

        new Timer(10, (ActionEvent e) -> {
            if (stack.size() < 50_000) {
                for (int i = 0; i < 1000; i++)
                    addPoint();
                repaint();
            }
        }).start();
    }

    private void addPoint() {
        try {
            int colorIndex = r.nextInt(3);
            Point p1 = stack.peek();
            Point p2 = points[colorIndex];
            stack.add(halfwayPoint(p1, p2, colorIndex));
        } catch (EmptyStackException e) {
            e.printStackTrace();
        }
    }

    void drawPoints(Graphics2D g) {
        for (ColoredPoint p : stack) {
            g.setColor(colors[p.colorIndex]);
            g.fillOval(p.x, p.y, 1, 1);
        }
    }

    ColoredPoint halfwayPoint(Point a, Point b, int idx) {
        return new ColoredPoint((a.x + b.x) / 2, (a.y + b.y) / 2, idx);
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        drawPoints(g);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Chaos Game");
            f.setResizable(false);
            f.add(new ChaosGame(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
