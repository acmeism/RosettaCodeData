import java.awt.*;
import javax.swing.*;

public class SternBrocot extends JPanel {

    public SternBrocot() {
        setPreferredSize(new Dimension(800, 500));
        setFont(new Font("Arial", Font.PLAIN, 18));
        setBackground(Color.white);
    }

    private void drawTree(int n1, int d1, int n2, int d2,
            int x, int y, int gap, int lvl, Graphics2D g) {

        if (lvl == 0)
            return;

        // mediant
        int numer = n1 + n2;
        int denom = d1 + d2;

        if (lvl > 1) {
            g.drawLine(x + 5, y + 4, x - gap + 5, y + 124);
            g.drawLine(x + 5, y + 4, x + gap + 5, y + 124);
        }

        g.setColor(getBackground());
        g.fillRect(x - 10, y - 15, 35, 40);

        g.setColor(getForeground());
        g.drawString(String.valueOf(numer), x, y);
        g.drawString("_", x, y + 2);
        g.drawString(String.valueOf(denom), x, y + 22);

        drawTree(n1, d1, numer, denom, x - gap, y + 120, gap / 2, lvl - 1, g);
        drawTree(numer, denom, n2, d2, x + gap, y + 120, gap / 2, lvl - 1, g);
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        int w = getWidth();

        drawTree(0, 1, 1, 0, w / 2, 50, w / 4, 4, g);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Stern-Brocot Tree");
            f.setResizable(false);
            f.add(new SternBrocot(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
