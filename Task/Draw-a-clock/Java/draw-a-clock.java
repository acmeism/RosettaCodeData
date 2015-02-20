import java.awt.*;
import java.awt.event.*;
import java.util.Calendar;
import javax.swing.*;

class Clock extends JPanel {

    final float degrees06 = (float) Math.toRadians(6);
    final float degrees30 = degrees06 * 5;
    final float degrees90 = degrees30 * 3;

    final int size = 550;
    final int spacing = 20;
    final int diameter = size - 2 * spacing;
    final int x = diameter / 2 + spacing;
    final int y = diameter / 2 + spacing;

    public Clock() {
        setPreferredSize(new Dimension(size, size));
        setBackground(Color.white);

        new Timer(1000, new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                repaint();
            }
        }).start();
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        g.setColor(Color.black);
        g.drawOval(spacing, spacing, diameter, diameter);

        Calendar date = Calendar.getInstance();
        int hours = date.get(Calendar.HOUR);
        int minutes = date.get(Calendar.MINUTE);
        int seconds = date.get(Calendar.SECOND);

        float angle = degrees90 - (degrees06 * seconds);
        drawHand(g, angle, diameter / 2 - 30, Color.red);

        float minsecs = (minutes + seconds / 60.0F);
        angle = degrees90 - (degrees06 * minsecs);
        drawHand(g, angle, diameter / 3 + 10, Color.black);

        float hourmins = (hours + minsecs / 60.0F);
        angle = degrees90 - (degrees30 * hourmins);
        drawHand(g, angle, diameter / 4 + 10, Color.black);
    }

    private void drawHand(Graphics2D g, float angle, int radius, Color color) {
        int x2 = x + (int) (radius * Math.cos(angle));
        int y2 = y + (int) (radius * Math.sin(-angle)); // flip y-axis
        g.setColor(color);
        g.drawLine(x, y, x2, y2);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                JFrame f = new JFrame();
                f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                f.setTitle("Clock");
                f.setResizable(false);
                f.add(new Clock(), BorderLayout.CENTER);
                f.pack();
                f.setLocationRelativeTo(null);
                f.setVisible(true);
            }
        });
    }
}
