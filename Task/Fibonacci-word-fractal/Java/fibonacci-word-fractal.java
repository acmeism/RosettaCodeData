import java.awt.*;
import javax.swing.*;

public class FibonacciWordFractal extends JPanel {
    String wordFractal;

    FibonacciWordFractal(int n) {
        setPreferredSize(new Dimension(450, 620));
        setBackground(Color.white);
        wordFractal = wordFractal(n);
    }

    public String wordFractal(int n) {
        if (n < 2)
            return n == 1 ? "1" : "";

        // we should really reserve fib n space here
        StringBuilder f1 = new StringBuilder("1");
        StringBuilder f2 = new StringBuilder("0");

        for (n = n - 2; n > 0; n--) {
            String tmp = f2.toString();
            f2.append(f1);

            f1.setLength(0);
            f1.append(tmp);
        }

        return f2.toString();
    }

    void drawWordFractal(Graphics2D g, int x, int y, int dx, int dy) {
        for (int n = 0; n < wordFractal.length(); n++) {
            g.drawLine(x, y, x + dx, y + dy);
            x += dx;
            y += dy;
            if (wordFractal.charAt(n) == '0') {
                int tx = dx;
                dx = (n % 2 == 0) ? -dy : dy;
                dy = (n % 2 == 0) ? tx : -tx;
            }
        }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        drawWordFractal(g, 20, 20, 1, 0);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Fibonacci Word Fractal");
            f.setResizable(false);
            f.add(new FibonacciWordFractal(23), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
