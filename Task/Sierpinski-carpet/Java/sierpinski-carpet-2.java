import java.awt.*;
import java.awt.event.ActionEvent;
import javax.swing.*;

public class SierpinskiCarpet extends JPanel {
    private final int dim = 513;
    private final int margin = 20;

    private int limit = dim;

    public SierpinskiCarpet() {
        setPreferredSize(new Dimension(dim + 2 * margin, dim + 2 * margin));
        setBackground(Color.white);
        setForeground(Color.orange);

        new Timer(2000, (ActionEvent e) -> {
            limit /= 3;
            if (limit <= 3)
                limit = dim;
            repaint();
        }).start();
    }

    void drawCarpet(Graphics2D g, int x, int y, int size) {
        if (size < limit)
            return;
        size /= 3;
        for (int i = 0; i < 9; i++) {
            if (i == 4) {
                g.fillRect(x + size, y + size, size, size);
            } else {
                drawCarpet(g, x + (i % 3) * size, y + (i / 3) * size, size);
            }
        }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        g.translate(margin, margin);
        drawCarpet(g, 0, 0, dim);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Sierpinski Carpet");
            f.setResizable(false);
            f.add(new SierpinskiCarpet(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
