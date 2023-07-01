import java.awt.*;
import java.awt.event.*;
import static java.lang.Math.*;
import java.time.LocalTime;
import javax.swing.*;

class Clock extends JPanel {

    final float degrees06 = (float) (PI / 30);
    final float degrees30 = degrees06 * 5;
    final float degrees90 = degrees30 * 3;

    final int size = 590;
    final int spacing = 40;
    final int diameter = size - 2 * spacing;
    final int cx = diameter / 2 + spacing;
    final int cy = diameter / 2 + spacing;

    public Clock() {
        setPreferredSize(new Dimension(size, size));
        setBackground(Color.white);

        new Timer(1000, (ActionEvent e) -> {
            repaint();
        }).start();
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        drawFace(g);

        final LocalTime time  = LocalTime.now();
        int hour = time.getHour();
        int minute = time.getMinute();
        int second = time.getSecond();

        float angle = degrees90 - (degrees06 * second);
        drawHand(g, angle, diameter / 2 - 30, Color.red);

        float minsecs = (minute + second / 60.0F);
        angle = degrees90 - (degrees06 * minsecs);
        drawHand(g, angle, diameter / 3 + 10, Color.black);

        float hourmins = (hour + minsecs / 60.0F);
        angle = degrees90 - (degrees30 * hourmins);
        drawHand(g, angle, diameter / 4 + 10, Color.black);
    }

    private void drawFace(Graphics2D g) {
        g.setStroke(new BasicStroke(2));
        g.setColor(Color.white);
        g.fillOval(spacing, spacing, diameter, diameter);
        g.setColor(Color.black);
        g.drawOval(spacing, spacing, diameter, diameter);
    }

    private void drawHand(Graphics2D g, float angle, int radius, Color color) {
        int x = cx + (int) (radius * cos(angle));
        int y = cy - (int) (radius * sin(angle));
        g.setColor(color);
        g.drawLine(cx, cy, x, y);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Clock");
            f.setResizable(false);
            f.add(new Clock(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
