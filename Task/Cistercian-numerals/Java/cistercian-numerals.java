import java.util.Arrays;
import java.util.List;

public class Cistercian {
    private static final int SIZE = 15;
    private final char[][] canvas = new char[SIZE][SIZE];

    public Cistercian(int n) {
        initN();
        draw(n);
    }

    public void initN() {
        for (var row : canvas) {
            Arrays.fill(row, ' ');
            row[5] = 'x';
        }
    }

    private void horizontal(int c1, int c2, int r) {
        for (int c = c1; c <= c2; c++) {
            canvas[r][c] = 'x';
        }
    }

    private void vertical(int r1, int r2, int c) {
        for (int r = r1; r <= r2; r++) {
            canvas[r][c] = 'x';
        }
    }

    private void diagd(int c1, int c2, int r) {
        for (int c = c1; c <= c2; c++) {
            canvas[r + c - c1][c] = 'x';
        }
    }

    private void diagu(int c1, int c2, int r) {
        for (int c = c1; c <= c2; c++) {
            canvas[r - c + c1][c] = 'x';
        }
    }

    private void draw(int v) {
        var thousands = v / 1000;
        v %= 1000;

        var hundreds = v / 100;
        v %= 100;

        var tens = v / 10;
        var ones = v % 10;

        drawPart(1000 * thousands);
        drawPart(100 * hundreds);
        drawPart(10 * tens);
        drawPart(ones);
    }

    private void drawPart(int v) {
        switch (v) {
            case 1:
                horizontal(6, 10, 0);
                break;
            case 2:
                horizontal(6, 10, 4);
                break;
            case 3:
                diagd(6, 10, 0);
                break;
            case 4:
                diagu(6, 10, 4);
                break;
            case 5:
                drawPart(1);
                drawPart(4);
                break;
            case 6:
                vertical(0, 4, 10);
                break;
            case 7:
                drawPart(1);
                drawPart(6);
                break;
            case 8:
                drawPart(2);
                drawPart(6);
                break;
            case 9:
                drawPart(1);
                drawPart(8);
                break;

            case 10:
                horizontal(0, 4, 0);
                break;
            case 20:
                horizontal(0, 4, 4);
                break;
            case 30:
                diagu(0, 4, 4);
                break;
            case 40:
                diagd(0, 4, 0);
                break;
            case 50:
                drawPart(10);
                drawPart(40);
                break;
            case 60:
                vertical(0, 4, 0);
                break;
            case 70:
                drawPart(10);
                drawPart(60);
                break;
            case 80:
                drawPart(20);
                drawPart(60);
                break;
            case 90:
                drawPart(10);
                drawPart(80);
                break;

            case 100:
                horizontal(6, 10, 14);
                break;
            case 200:
                horizontal(6, 10, 10);
                break;
            case 300:
                diagu(6, 10, 14);
                break;
            case 400:
                diagd(6, 10, 10);
                break;
            case 500:
                drawPart(100);
                drawPart(400);
                break;
            case 600:
                vertical(10, 14, 10);
                break;
            case 700:
                drawPart(100);
                drawPart(600);
                break;
            case 800:
                drawPart(200);
                drawPart(600);
                break;
            case 900:
                drawPart(100);
                drawPart(800);
                break;

            case 1000:
                horizontal(0, 4, 14);
                break;
            case 2000:
                horizontal(0, 4, 10);
                break;
            case 3000:
                diagd(0, 4, 10);
                break;
            case 4000:
                diagu(0, 4, 14);
                break;
            case 5000:
                drawPart(1000);
                drawPart(4000);
                break;
            case 6000:
                vertical(10, 14, 0);
                break;
            case 7000:
                drawPart(1000);
                drawPart(6000);
                break;
            case 8000:
                drawPart(2000);
                drawPart(6000);
                break;
            case 9000:
                drawPart(1000);
                drawPart(8000);
                break;

        }
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        for (var row : canvas) {
            builder.append(row);
            builder.append('\n');
        }
        return builder.toString();
    }

    public static void main(String[] args) {
        for (int number : List.of(0, 1, 20, 300, 4000, 5555, 6789, 9999)) {
            System.out.printf("%d:\n", number);
            var c = new Cistercian(number);
            System.out.println(c);
        }
    }
}
