import java.io.*;

public class SierpinskiSquareCurve {
    public static void main(final String[] args) {
        try (Writer writer = new BufferedWriter(new FileWriter("sierpinski_square.svg"))) {
            SierpinskiSquareCurve s = new SierpinskiSquareCurve(writer);
            int size = 635, length = 5;
            s.currentAngle = 0;
            s.currentX = (size - length)/2;
            s.currentY = length;
            s.lineLength = length;
            s.begin(size);
            s.execute(rewrite(5));
            s.end();
        } catch (final Exception ex) {
            ex.printStackTrace();
        }
    }

    private SierpinskiSquareCurve(final Writer writer) {
        this.writer = writer;
    }

    private void begin(final int size) throws IOException {
        write("<svg xmlns='http://www.w3.org/2000/svg' width='%d' height='%d'>\n", size, size);
        write("<rect width='100%%' height='100%%' fill='white'/>\n");
        write("<path stroke-width='1' stroke='black' fill='none' d='");
    }

    private void end() throws IOException {
        write("'/>\n</svg>\n");
    }

    private void execute(final String s) throws IOException {
        write("M%g,%g\n", currentX, currentY);
        for (int i = 0, n = s.length(); i < n; ++i) {
            switch (s.charAt(i)) {
                case 'F':
                    line(lineLength);
                    break;
                case '+':
                    turn(ANGLE);
                    break;
                case '-':
                    turn(-ANGLE);
                    break;
            }
        }
    }

    private void line(final double length) throws IOException {
        final double theta = (Math.PI * currentAngle) / 180.0;
        currentX += length * Math.cos(theta);
        currentY += length * Math.sin(theta);
        write("L%g,%g\n", currentX, currentY);
    }

    private void turn(final int angle) {
        currentAngle = (currentAngle + angle) % 360;
    }

    private void write(final String format, final Object... args) throws IOException {
        writer.write(String.format(format, args));
    }

    private static String rewrite(final int order) {
        String s = AXIOM;
        for (int i = 0; i < order; ++i) {
            final StringBuilder sb = new StringBuilder();
            for (int j = 0, n = s.length(); j < n; ++j) {
                final char ch = s.charAt(j);
                if (ch == 'X')
                    sb.append(PRODUCTION);
                else
                    sb.append(ch);
            }
            s = sb.toString();
        }
        return s;
    }

    private final Writer writer;
    private double lineLength;
    private double currentX;
    private double currentY;
    private int currentAngle;

    private static final String AXIOM = "F+XF+F+XF";
    private static final String PRODUCTION = "XF-F+F-XF+F+XF-F+F-X";
    private static final int ANGLE = 90;
}
