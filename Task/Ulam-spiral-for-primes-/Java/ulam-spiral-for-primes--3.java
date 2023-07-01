import java.awt.*;
import javax.swing.*;

public class UlamSpiral extends JPanel {

    Font primeFont = new Font("Arial", Font.BOLD, 20);
    Font compositeFont = new Font("Arial", Font.PLAIN, 16);

    public UlamSpiral() {
        setPreferredSize(new Dimension(640, 640));
        setBackground(Color.white);
    }

    private boolean isPrime(int n) {
        if (n <= 2 || n % 2 == 0)
            return n == 2;
        for (int i = 3; i * i <= n; i += 2)
            if (n % i == 0)
                return false;
        return true;
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        g.setStroke(new BasicStroke(2));

        double angle = 0.0;
        int x = 280, y = 330, dx = 1, dy = 0;

        g.setColor(getForeground());
        g.drawLine(x, y - 5, x + 50, y - 5);

        for (int i = 1, step = 1, turn = 1; i < 100; i++) {

            g.setColor(getBackground());
            g.fillRect(x - 5, y - 20, 30, 30);
            g.setColor(getForeground());
            g.setFont(isPrime(i) ? primeFont : compositeFont);
            g.drawString(String.valueOf(i), x + (i < 10 ? 4 : 0), y);

            x += dx * 50;
            y += dy * 50;

            if (i == turn) {
                angle += 90.0;

                if ((dx == 0 && dy == -1) || (dx == 0 && dy == 1))
                    step++;

                turn += step;

                dx = (int) Math.cos(Math.toRadians(angle));
                dy = (int) Math.sin(Math.toRadians(-angle));

                g.translate(9, -5);
                g.drawLine(x, y, x + dx * step * 50, y + dy * step * 50);
                g.translate(-9, 5);
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Ulam Spiral");
            f.setResizable(false);
            f.add(new UlamSpiral(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
