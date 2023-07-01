import java.awt.*;
import static java.awt.Color.*;
import javax.swing.*;

public class ColourPinstripeDisplay extends JPanel {
    final static Color[] palette = {black, red, green, blue, magenta,cyan,
        yellow, white};

    final int bands = 4;

    public ColourPinstripeDisplay() {
        setPreferredSize(new Dimension(900, 600));
    }

    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        int h = getHeight();
        for (int b = 1; b <= bands; b++) {
            for (int x = 0, colIndex = 0; x < getWidth(); x += b, colIndex++) {
                g.setColor(palette[colIndex % palette.length]);
                g.fillRect(x, (b - 1) * (h / bands), x + b, b * (h / bands));
            }
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("ColourPinstripeDisplay");
            f.add(new ColourPinstripeDisplay(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
