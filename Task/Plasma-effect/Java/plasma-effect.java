import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import static java.awt.image.BufferedImage.*;
import static java.lang.Math.*;
import javax.swing.*;

public class PlasmaEffect extends JPanel {
    float[][] plasma;
    float hueShift = 0;
    BufferedImage img;

    public PlasmaEffect() {
        Dimension dim = new Dimension(640, 640);
        setPreferredSize(dim);
        setBackground(Color.white);

        img = new BufferedImage(dim.width, dim.height, TYPE_INT_RGB);
        plasma = createPlasma(dim.height, dim.width);

        // animate about 24 fps and shift hue value with every frame
        new Timer(42, (ActionEvent e) -> {
            hueShift = (hueShift + 0.02f) % 1;
            repaint();
        }).start();
    }

    float[][] createPlasma(int w, int h) {
        float[][] buffer = new float[h][w];

        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++) {

                double value = sin(x / 16.0);
                value += sin(y / 8.0);
                value += sin((x + y) / 16.0);
                value += sin(sqrt(x * x + y * y) / 8.0);
                value += 4; // shift range from -4 .. 4 to 0 .. 8
                value /= 8; // bring range down to 0 .. 1

                // requires VM option -ea
                assert (value >= 0.0 && value <= 1.0) : "Hue value out of bounds";

                buffer[y][x] = (float) value;
            }
        return buffer;
    }

    void drawPlasma(Graphics2D g) {
        int h = plasma.length;
        int w = plasma[0].length;
        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++) {
                float hue = hueShift + plasma[y][x] % 1;
                img.setRGB(x, y, Color.HSBtoRGB(hue, 1, 1));
            }
        g.drawImage(img, 0, 0, null);
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        drawPlasma(g);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Plasma Effect");
            f.setResizable(false);
            f.add(new PlasmaEffect(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
