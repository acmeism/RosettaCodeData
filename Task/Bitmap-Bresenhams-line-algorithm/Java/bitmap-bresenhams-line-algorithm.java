import java.awt.*;
import javax.swing.*;

public class Bresenham extends JFrame {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                JFrame f = new Bresenham();
                f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                f.setVisible(true);
                f.add(new BresenhamPanel(), BorderLayout.CENTER);
                f.setTitle("Bresenham");
                f.setResizable(false);
                f.pack();
                f.setLocationRelativeTo(null);
            }
        });
    }
}

class BresenhamPanel extends JPanel {
    final int centerX, centerY;

    public BresenhamPanel() {
        int w = 600;
        int h = 500;
        centerX = w / 2;
        centerY = h / 2;
        setPreferredSize(new Dimension(w, h));
        setBackground(Color.white);
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);

        drawLine(g, 0, 0, 8, 19); // NNE
        drawLine(g, 0, 0, 19, 8); // ENE
        drawLine(g, 0, 0, 19, -8); // ESE
        drawLine(g, 0, 0, 8, -19); // SSE
        drawLine(g, 0, 0, -8, -19); // SSW
        drawLine(g, 0, 0, -19, -8); // WSW
        drawLine(g, 0, 0, -19, 8); // WNW
        drawLine(g, 0, 0, -8, 19); // NNW
    }

    private void plot(Graphics g, int x, int y) {
        g.setColor(Color.black);
        g.drawOval(centerX + (x * 10), centerY + (-y * 10), 10, 10);
    }

    private void drawLine(Graphics g, int x1, int y1, int x2, int y2) {
        // delta of exact value and rounded value of the dependant variable
        int d = 0;

        int dy = Math.abs(y2 - y1);
        int dx = Math.abs(x2 - x1);

        int dy2 = (dy << 1); // slope scaling factors to avoid floating
        int dx2 = (dx << 1); // point

        int ix = x1 < x2 ? 1 : -1; // increment direction
        int iy = y1 < y2 ? 1 : -1;

        if (dy <= dx) {
            for (;;) {
                plot(g, x1, y1);
                if (x1 == x2)
                    break;
                x1 += ix;
                d += dy2;
                if (d > dx) {
                    y1 += iy;
                    d -= dx2;
                }
            }
        } else {
            for (;;) {
                plot(g, x1, y1);
                if (y1 == y2)
                    break;
                y1 += iy;
                d += dx2;
                if (d > dy) {
                    x1 += ix;
                    d -= dy2;
                }
            }
        }
    }
}
