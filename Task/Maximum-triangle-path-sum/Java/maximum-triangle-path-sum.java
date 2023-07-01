import java.nio.file.*;
import static java.util.Arrays.stream;

public class MaxPathSum {

    public static void main(String[] args) throws Exception {
        int[][] data = Files.lines(Paths.get("triangle.txt"))
                .map(s -> stream(s.trim().split("\\s+"))
                        .mapToInt(Integer::parseInt)
                        .toArray())
                .toArray(int[][]::new);

        for (int r = data.length - 1; r > 0; r--)
            for (int c = 0; c < data[r].length - 1; c++)
                data[r - 1][c] += Math.max(data[r][c], data[r][c + 1]);

        System.out.println(data[0][0]);
    }
}
