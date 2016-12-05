import java.awt.*;
import javax.swing.*;

public class LargeUlamSpiral extends JPanel {

    public LargeUlamSpiral() {
        setPreferredSize(new Dimension(605, 605));
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

        g.setColor(getForeground());

        double angle = 0.0;
        int x = 300, y = 300, dx = 1, dy = 0;

        for (int i = 1, step = 1, turn = 1; i < 40_000; i++) {

            if (isPrime(i))
                g.fillRect(x, y, 2, 2);

            x += dx * 3;
            y += dy * 3;

            if (i == turn) {

                angle += 90.0;

                if ((dx == 0 && dy == -1) || (dx == 0 && dy == 1))
                    step++;

                turn += step;

                dx = (int) Math.cos(Math.toRadians(angle));
                dy = (int) Math.sin(Math.toRadians(-angle));
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Large Ulam Spiral");
            f.setResizable(false);
            f.add(new LargeUlamSpiral(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
