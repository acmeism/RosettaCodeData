import java.awt.*;
import java.awt.geom.Path2D;
import static java.lang.Math.pow;
import java.util.Hashtable;
import javax.swing.*;
import javax.swing.event.*;

public class SuperEllipse extends JPanel implements ChangeListener {
    private double exp = 2.5;

    public SuperEllipse() {
        setPreferredSize(new Dimension(650, 650));
        setBackground(Color.white);
        setFont(new Font("Serif", Font.PLAIN, 18));
    }

    void drawGrid(Graphics2D g) {
        g.setStroke(new BasicStroke(2));
        g.setColor(new Color(0xEEEEEE));

        int w = getWidth();
        int h = getHeight();
        int spacing = 25;

        for (int i = 0; i < w / spacing; i++) {
            g.drawLine(0, i * spacing, w, i * spacing);
            g.drawLine(i * spacing, 0, i * spacing, w);
        }
        g.drawLine(0, h - 1, w, h - 1);

        g.setColor(new Color(0xAAAAAA));
        g.drawLine(0, w / 2, w, w / 2);
        g.drawLine(w / 2, 0, w / 2, w);
    }

    void drawLegend(Graphics2D g) {
        g.setColor(Color.black);
        g.setFont(getFont());
        g.drawString("n = " + String.valueOf(exp), getWidth() - 150, 45);
        g.drawString("a = b = 200", getWidth() - 150, 75);
    }

    void drawEllipse(Graphics2D g) {

        final int a = 200; // a = b
        double[] points = new double[a + 1];

        Path2D p = new Path2D.Double();
        p.moveTo(a, 0);

        // calculate first quadrant
        for (int x = a; x >= 0; x--) {
            points[x] = pow(pow(a, exp) - pow(x, exp), 1 / exp); // solve for y
            p.lineTo(x, -points[x]);
        }

        // mirror to others
        for (int x = 0; x <= a; x++)
            p.lineTo(x, points[x]);

        for (int x = a; x >= 0; x--)
            p.lineTo(-x, points[x]);

        for (int x = 0; x <= a; x++)
            p.lineTo(-x, -points[x]);

        g.translate(getWidth() / 2, getHeight() / 2);
        g.setStroke(new BasicStroke(2));

        g.setColor(new Color(0x25B0C4DE, true));
        g.fill(p);

        g.setColor(new Color(0xB0C4DE)); // LightSteelBlue
        g.draw(p);
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        g.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING,
                RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

        drawGrid(g);
        drawLegend(g);
        drawEllipse(g);
    }

    @Override
    public void stateChanged(ChangeEvent e) {
        JSlider source = (JSlider) e.getSource();
        exp = source.getValue() / 2.0;
        repaint();
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Super Ellipse");
            f.setResizable(false);
            SuperEllipse panel = new SuperEllipse();
            f.add(panel, BorderLayout.CENTER);

            JSlider exponent = new JSlider(JSlider.HORIZONTAL, 1, 9, 5);
            exponent.addChangeListener(panel);
            exponent.setMajorTickSpacing(1);
            exponent.setPaintLabels(true);
            exponent.setBackground(Color.white);
            exponent.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

            Hashtable<Integer, JLabel> labelTable = new Hashtable<>();
            for (int i = 1; i < 10; i++)
                labelTable.put(i, new JLabel(String.valueOf(i * 0.5)));
            exponent.setLabelTable(labelTable);

            f.add(exponent, BorderLayout.SOUTH);

            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
