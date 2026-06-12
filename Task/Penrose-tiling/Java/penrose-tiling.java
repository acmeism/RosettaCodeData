import java.awt.*;
import java.util.List;
import java.awt.geom.Path2D;
import java.util.*;
import javax.swing.*;
import static java.lang.Math.*;
import static java.util.stream.Collectors.toList;

public class PenroseTiling extends JPanel {
    // ignores missing hash code
    class Tile {
        double x, y, angle, size;
        Type type;

        Tile(Type t, double x, double y, double a, double s) {
            type = t;
            this.x = x;
            this.y = y;
            angle = a;
            size = s;
        }

        @Override
        public boolean equals(Object o) {
            if (o instanceof Tile) {
                Tile t = (Tile) o;
                return type == t.type && x == t.x && y == t.y && angle == t.angle;
            }
            return false;
        }
    }

    enum Type {
        Kite, Dart
    }

    static final double G = (1 + sqrt(5)) / 2; // golden ratio
    static final double T = toRadians(36); // theta

    List<Tile> tiles = new ArrayList<>();

    public PenroseTiling() {
        int w = 700, h = 450;
        setPreferredSize(new Dimension(w, h));
        setBackground(Color.white);

        tiles = deflateTiles(setupPrototiles(w, h), 5);
    }

    List<Tile> setupPrototiles(int w, int h) {
        List<Tile> proto = new ArrayList<>();

        // sun
        for (double a = PI / 2 + T; a < 3 * PI; a += 2 * T)
            proto.add(new Tile(Type.Kite, w / 2, h / 2, a, w / 2.5));

        return proto;
    }

    List<Tile> deflateTiles(List<Tile> tls, int generation) {
        if (generation <= 0)
            return tls;

        List<Tile> next = new ArrayList<>();

        for (Tile tile : tls) {
            double x = tile.x, y = tile.y, a = tile.angle, nx, ny;
            double size = tile.size / G;

            if (tile.type == Type.Dart) {
                next.add(new Tile(Type.Kite, x, y, a + 5 * T, size));

                for (int i = 0, sign = 1; i < 2; i++, sign *= -1) {
                    nx = x + cos(a - 4 * T * sign) * G * tile.size;
                    ny = y - sin(a - 4 * T * sign) * G * tile.size;
                    next.add(new Tile(Type.Dart, nx, ny, a - 4 * T * sign, size));
                }

            } else {

                for (int i = 0, sign = 1; i < 2; i++, sign *= -1) {
                    next.add(new Tile(Type.Dart, x, y, a - 4 * T * sign, size));

                    nx = x + cos(a - T * sign) * G * tile.size;
                    ny = y - sin(a - T * sign) * G * tile.size;
                    next.add(new Tile(Type.Kite, nx, ny, a + 3 * T * sign, size));
                }
            }
        }
        // remove duplicates
        tls = next.stream().distinct().collect(toList());

        return deflateTiles(tls, generation - 1);
    }

    void drawTiles(Graphics2D g) {
        double[][] dist = {{G, G, G}, {-G, -1, -G}};
        for (Tile tile : tiles) {
            double angle = tile.angle - T;
            Path2D path = new Path2D.Double();
            path.moveTo(tile.x, tile.y);

            int ord = tile.type.ordinal();
            for (int i = 0; i < 3; i++) {
                double x = tile.x + dist[ord][i] * tile.size * cos(angle);
                double y = tile.y - dist[ord][i] * tile.size * sin(angle);
                path.lineTo(x, y);
                angle += T;
            }
            path.closePath();
            g.setColor(ord == 0 ? Color.orange : Color.yellow);
            g.fill(path);
            g.setColor(Color.darkGray);
            g.draw(path);
        }
    }

    @Override
    public void paintComponent(Graphics og) {
        super.paintComponent(og);
        Graphics2D g = (Graphics2D) og;
        g.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON);
        drawTiles(g);
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame f = new JFrame();
            f.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            f.setTitle("Penrose Tiling");
            f.setResizable(false);
            f.add(new PenroseTiling(), BorderLayout.CENTER);
            f.pack();
            f.setLocationRelativeTo(null);
            f.setVisible(true);
        });
    }
}
