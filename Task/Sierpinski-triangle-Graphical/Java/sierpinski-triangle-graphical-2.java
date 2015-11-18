import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.geom.Path2D;
import javax.swing.*;

public class SierpinskiTriangle extends JPanel {
    private final int dim = 512;
    private final int margin = 20;

    private int limit = dim;

    public SierpinskiTriangle() {
        setPreferredSize(new Dimension(dim + 2 * margin, dim + 2 * margin));
        setBackground(Color.white);
        setForeground(Color.green.darker());

        new Timer(2000, (ActionEvent e) -> {
            limit /= 2;
            if (limit <= 2)
                limit = dim;
            repaint();
        }).start();
    }

    void drawTriangle(Graphics2D g, int x, int y, int size) {
        if (size <= limit) {
            Path2D p = new Path2D.Float();
            p.moveTo(x, y);
            p.lineTo(x + size / 2, y + size);
            p.lineTo(x - size / 2, y + size);
            g.fill(p);
        } else {
            size /= 2;
            drawTriangle(g, x, y, size);
            drawTriangle(g, x + size / 2, y + size, size);
            drawTriangle(g, x - size / 2, y + size, size);
        }
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        g.translate(margin, margin);
        drawTriangle(g, dim / 2, 0, dim);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Sierpinski Triangle");
            f.setResizable(false);
            f.add(new SierpinskiTriangle(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
