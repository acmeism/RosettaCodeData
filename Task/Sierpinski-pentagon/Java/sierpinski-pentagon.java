import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.geom.Path2D;
import static java.lang.Math.*;
import java.util.Random;
import javax.swing.*;

public class SierpinskiPentagon extends JPanel {
    // exterior angle
    final double degrees072 = toRadians(72);

    /* After scaling we'll have 2 sides plus a gap occupying the length
       of a side before scaling. The gap is the base of an isosceles triangle
       with a base angle of 72 degrees. */
    final double scaleFactor = 1 / (2 + cos(degrees072) * 2);

    final int margin = 20;
    int limit = 0;
    Random r = new Random();

    public SierpinskiPentagon() {
        setPreferredSize(new Dimension(640, 640));
        setBackground(Color.white);

        new Timer(3000, (ActionEvent e) -> {
            limit++;
            if (limit >= 5)
                limit = 0;
            repaint();
        }).start();
    }

    void drawPentagon(Graphics2D g, double x, double y, double side, int depth) {
        double angle = 3 * degrees072; // starting angle

        if (depth == 0) {

            Path2D p = new Path2D.Double();
            p.moveTo(x, y);

            // draw from the top
            for (int i = 0; i < 5; i++) {
                x = x + cos(angle) * side;
                y = y - sin(angle) * side;
                p.lineTo(x, y);
                angle += degrees072;
            }

            g.setColor(RandomHue.next());
            g.fill(p);

        } else {

            side *= scaleFactor;

            /* Starting at the top of the highest pentagon, calculate
               the top vertices of the other pentagons by taking the
               length of the scaled side plus the length of the gap. */
            double distance = side + side * cos(degrees072) * 2;

            /* The top positions form a virtual pentagon of their own,
               so simply move from one to the other by changing direction. */
            for (int i = 0; i < 5; i++) {
                x = x + cos(angle) * distance;
                y = y - sin(angle) * distance;
                drawPentagon(g, x, y, side, depth - 1);
                angle += degrees072;
            }
        }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        int w = getWidth();
        double radius = w / 2 - 2 * margin;
        double side = radius * sin(PI / 5) * 2;

        drawPentagon(g, w / 2, 3 * margin, side, limit);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Sierpinski Pentagon");
            f.setResizable(true);
            f.add(new SierpinskiPentagon(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}

class RandomHue {
    /* Try to avoid random color values clumping together */
    final static double goldenRatioConjugate = (sqrt(5) - 1) / 2;
    private static double hue = Math.random();

    static Color next() {
        hue = (hue + goldenRatioConjugate) % 1;
        return Color.getHSBColor((float) hue, 1, 1);
    }
}
