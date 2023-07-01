class CutRectangle {
    private static int[][] dirs = [[0, -1], [-1, 0], [0, 1], [1, 0]]

    static void main(String[] args) {
        cutRectangle(2, 2)
        cutRectangle(4, 3)
    }

    static void cutRectangle(int w, int h) {
        if (w % 2 == 1 && h % 2 == 1) {
            return
        }

        int[][] grid = new int[h][w]
        Stack<Integer> stack = new Stack<>()

        int half = (int) ((w * h) / 2)
        long bits = (long) Math.pow(2, half) - 1

        for (; bits > 0; bits -= 2) {
            for (int i = 0; i < half; i++) {
                int r = (int) (i / w)
                int c = i % w
                grid[r][c] = (bits & (1 << i)) != 0 ? 1 : 0
                grid[h - r - 1][w - c - 1] = 1 - grid[r][c]
            }

            stack.push(0)
            grid[0][0] = 2
            int count = 1
            while (!stack.empty()) {
                int pos = stack.pop()
                int r = (int) (pos / w)
                int c = pos % w

                for (int[] dir : dirs) {
                    int nextR = r + dir[0]
                    int nextC = c + dir[1]

                    if (nextR >= 0 && nextR < h && nextC >= 0 && nextC < w) {
                        if (grid[nextR][nextC] == 1) {
                            stack.push(nextR * w + nextC)
                            grid[nextR][nextC] = 2
                            count++
                        }
                    }
                }
            }
            if (count == half) {
                printResult(grid)
            }
        }
    }

    static void printResult(int[][] arr) {
        for (int[] a : arr) {
            println(Arrays.toString(a))
        }
        println()
    }
}
