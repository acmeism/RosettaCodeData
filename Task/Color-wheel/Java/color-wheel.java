import java.awt.*;
import javax.swing.*;

public class ColorWheel {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            public void run() {
                ColorWheelFrame frame = new ColorWheelFrame();
                frame.setVisible(true);
            }
        });
    }

    private static class ColorWheelFrame extends JFrame {
        private ColorWheelFrame() {
            super("Color Wheel");
            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            getContentPane().add(new ColorWheelPanel());
            pack();
        }
    }

    private static class ColorWheelPanel extends JComponent {
        private ColorWheelPanel() {
            setPreferredSize(new Dimension(400, 400));
        }
        public void paint(Graphics g) {
            Graphics2D g2 = (Graphics2D)g;
            int w = getWidth();
            int h = getHeight();
            int margin = 10;
            int radius = (Math.min(w, h) - 2 * margin)/2;
            int cx = w/2;
            int cy = h/2;
            float[] dist = {0.F, 1.0F};
            g2.setColor(Color.BLACK);
            g2.fillRect(0, 0, w, h);
            for (int angle = 0; angle < 360; ++angle) {
                Color color = hsvToRgb(angle, 1.0, 1.0);
                Color[] colors = {Color.WHITE, color};
                RadialGradientPaint paint = new RadialGradientPaint(cx, cy,
                        radius, dist, colors);
                g2.setPaint(paint);
                g2.fillArc(cx - radius, cy - radius, radius*2, radius*2,
                        angle, 1);
            }
        }
    }

    private static Color hsvToRgb(int h, double s, double v) {
        double hp = h/60.0;
        double c = s * v;
        double x = c * (1 - Math.abs(hp % 2.0 - 1));
        double m = v - c;
        double r = 0, g = 0, b = 0;
        if (hp <= 1) {
            r = c;
            g = x;
        } else if (hp <= 2) {
            r = x;
            g = c;
        } else if (hp <= 3) {
            g = c;
            b = x;
        } else if (hp <= 4) {
            g = x;
            b = c;
        } else if (hp <= 5) {
            r = x;
            b = c;
        } else {
            r = c;
            b = x;
        }
        r += m;
        g += m;
        b += m;
        return new Color((int)(r * 255), (int)(g * 255), (int)(b * 255));
    }
}
