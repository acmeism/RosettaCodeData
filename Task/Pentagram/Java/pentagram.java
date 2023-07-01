import java.awt.*;
import java.awt.geom.Path2D;
import javax.swing.*;

public class Pentagram extends JPanel {

    final double degrees144 = Math.toRadians(144);

    public Pentagram() {
        setPreferredSize(new Dimension(640, 640));
        setBackground(Color.white);
    }

    private void drawPentagram(Graphics2D g, int len, int x, int y,
            Color fill, Color stroke) {
        double angle = 0;

        Path2D p = new Path2D.Float();
        p.moveTo(x, y);

        for (int i = 0; i < 5; i++) {
            int x2 = x + (int) (Math.cos(angle) * len);
            int y2 = y + (int) (Math.sin(-angle) * len);
            p.lineTo(x2, y2);
            x = x2;
            y = y2;
            angle -= degrees144;
        }
        p.closePath();

        g.setColor(fill);
        g.fill(p);

        g.setColor(stroke);
        g.draw(p);
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;

        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        g.setStroke(new BasicStroke(5, BasicStroke.CAP_ROUND, 0));

        drawPentagram(g, 500, 70, 250, new Color(0x6495ED), Color.darkGray);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Pentagram");
            f.setResizable(false);
            f.add(new Pentagram(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
