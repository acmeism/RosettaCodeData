import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

public class Honeycombs extends JFrame {

    HoneycombsPanel panel;

    public static void main(String[] args) {
        JFrame f = new Honeycombs();
        f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        f.setVisible(true);
    }

    public Honeycombs() {
        Container content = getContentPane();
        content.setLayout(new BorderLayout());
        panel = new HoneycombsPanel();
        content.add(panel, BorderLayout.CENTER);
        setTitle("Honeycombs");
        setResizable(false);
        pack();
        setLocationRelativeTo(null);
    }
}

class HoneycombsPanel extends JPanel {

    Hexagon[] comb;

    public HoneycombsPanel() {
        setPreferredSize(new Dimension(600, 500));
        setBackground(Color.white);
        setFocusable(true);

        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                for (Hexagon hex : comb)
                    if (hex.contains(e.getX(), e.getY())) {
                        hex.setSelected();
                        break;
                    }
                repaint();
            }
        });

        addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                for (Hexagon hex : comb)
                    if (hex.letter == Character.toUpperCase(e.getKeyChar())) {
                        hex.setSelected();
                        break;
                    }
                repaint();
            }
        });

        char[] letters = "LRDGITPFBVOKANUYCESM".toCharArray();
        comb = new Hexagon[20];

        int x1 = 150, y1 = 100, x2 = 225, y2 = 143, w = 150, h = 87;
        for (int i = 0; i < comb.length; i++) {
            int x, y;
            if (i < 12) {
                x = x1 + (i % 3) * w;
                y = y1 + (i / 3) * h;
            } else {
                x = x2 + (i % 2) * w;
                y = y2 + ((i - 12) / 2) * h;
            }
            comb[i] = new Hexagon(x, y, w / 3, letters[i]);
        }

        requestFocus();
    }

    @Override
    public void paintComponent(Graphics gg) {
        super.paintComponent(gg);
        Graphics2D g = (Graphics2D) gg;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);

        g.setFont(new Font("SansSerif", Font.BOLD, 30));
        g.setStroke(new BasicStroke(3));

        for (Hexagon hex : comb)
            hex.draw(g);
    }
}

class Hexagon extends Polygon {
    final Color baseColor = Color.yellow;
    final Color selectedColor = Color.magenta;
    final char letter;

    private boolean hasBeenSelected;

    Hexagon(int x, int y, int halfWidth, char c) {
        letter = c;
        for (int i = 0; i < 6; i++)
            addPoint((int) (x + halfWidth * Math.cos(i * Math.PI / 3)),
                     (int) (y + halfWidth * Math.sin(i * Math.PI / 3)));
        getBounds();
    }

    void setSelected() {
        hasBeenSelected = true;
    }

    void draw(Graphics2D g) {
        g.setColor(hasBeenSelected ? selectedColor : baseColor);
        g.fillPolygon(this);

        g.setColor(Color.black);
        g.drawPolygon(this);

        g.setColor(hasBeenSelected ? Color.black : Color.red);
        drawCenteredString(g, String.valueOf(letter));
    }

    void drawCenteredString(Graphics2D g, String s) {
        FontMetrics fm = g.getFontMetrics();
        int asc = fm.getAscent();
        int dec = fm.getDescent();

        int x = bounds.x + (bounds.width - fm.stringWidth(s)) / 2;
        int y = bounds.y + (asc + (bounds.height - (asc + dec)) / 2);

        g.drawString(s, x, y);
    }
}
