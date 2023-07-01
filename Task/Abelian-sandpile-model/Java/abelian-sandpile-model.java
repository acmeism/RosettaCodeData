import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class AbelianSandpile {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                Frame frame = new Frame();
                frame.setVisible(true);
            }
        });
    }

    private static class Frame extends JFrame {
        private Frame() {
            super("Abelian Sandpile Model");
            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            Container contentPane = getContentPane();
            JPanel controlPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
            JButton start = new JButton("Restart Simulation");
            start.addActionListener(e -> restartSimulation());
            JButton stop = new JButton("Stop Simulation");
            stop.addActionListener(e -> stopSimulation());
            controlPanel.add(start);
            controlPanel.add(stop);
            contentPane.add(controlPanel, BorderLayout.NORTH);
            contentPane.add(canvas = new Canvas(), BorderLayout.CENTER);
            timer = new Timer(100, e -> canvas.runAndDraw());
            timer.start();
            pack();
        }

        private void restartSimulation() {
            timer.stop();
            canvas.initGrid();
            timer.start();
        }

        private void stopSimulation() {
            timer.stop();
        }

        private Timer timer;
        private Canvas canvas;
    }

    private static class Canvas extends JComponent {
        private Canvas() {
            setBorder(BorderFactory.createEtchedBorder());
            setPreferredSize(new Dimension(600, 600));
        }

        public void paintComponent(Graphics g) {
            int width = getWidth();
            int height = getHeight();
            g.setColor(Color.WHITE);
            g.fillRect(0, 0, width, height);
            int cellWidth = width/GRID_LENGTH;
            int cellHeight = height/GRID_LENGTH;
            for (int i = 0; i < GRID_LENGTH; ++i) {
                for (int j = 0; j < GRID_LENGTH; ++j) {
                    if (grid[i][j] > 0) {
                        g.setColor(COLORS[grid[i][j]]);
                        g.fillRect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
                    }
                }
            }
        }

        private void initGrid() {
            for (int i = 0; i < GRID_LENGTH; ++i) {
                for (int j = 0; j < GRID_LENGTH; ++j) {
                    grid[i][j] = 0;
                }
            }
        }

        private void runAndDraw() {
            for (int i = 0; i < 100; ++i)
                addSand(GRID_LENGTH/2, GRID_LENGTH/2);
            repaint();
        }

        private void addSand(int i, int j) {
            int grains = grid[i][j];
            if (grains < 3) {
                grid[i][j]++;
            }
            else {
                grid[i][j] = grains - 3;
                if (i > 0)
                    addSand(i - 1, j);
                if (i < GRID_LENGTH - 1)
                    addSand(i + 1, j);
                if (j > 0)
                    addSand(i, j - 1);
                if (j < GRID_LENGTH - 1)
                    addSand(i, j + 1);
            }
        }

        private int[][] grid = new int[GRID_LENGTH][GRID_LENGTH];
    }

    private static final Color[] COLORS = {
        Color.WHITE,
        new Color(0x00, 0xbf, 0xff),
        new Color(0xff, 0xd7, 0x00),
        new Color(0xb0, 0x30, 0x60)
    };
    private static final int GRID_LENGTH = 300;
}
