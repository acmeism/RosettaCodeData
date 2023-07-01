class App {
    private static final int WIDTH = 81
    private static final int HEIGHT = 5

    private static char[][] lines
    static {
        lines = new char[HEIGHT][WIDTH]
        for (int i = 0; i < HEIGHT; i++) {
            for (int j = 0; j < WIDTH; j++) {
                lines[i][j] = '*'
            }
        }
    }

    private static void cantor(int start, int len, int index) {
        int seg = (int) (len / 3)
        if (seg == 0) return
        for (int i = index; i < HEIGHT; i++) {
            for (int j = start + seg; j < start + seg * 2; j++) {
                lines[i][j] = ' '
            }
        }
        cantor(start, seg, index + 1)
        cantor(start + seg * 2, seg, index + 1)
    }

    static void main(String[] args) {
        cantor(0, WIDTH, 1)
        for (int i = 0; i < HEIGHT; i++) {
            for (int j = 0; j < WIDTH; j++) {
                System.out.print(lines[i][j])
            }
            System.out.println()
        }
    }
}
