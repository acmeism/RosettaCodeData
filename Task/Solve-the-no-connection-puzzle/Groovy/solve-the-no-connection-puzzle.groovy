import java.util.stream.Collectors
import java.util.stream.IntStream

class NoConnection {
    // adopted from Go
    static int[][] links = [
            [2, 3, 4], // A to C,D,E
            [3, 4, 5], // B to D,E,F
            [2, 4],    // D to C, E
            [5],       // E to F
            [2, 3, 4], // G to C,D,E
            [3, 4, 5], // H to D,E,F
    ]

    static int[] pegs = new int[8]

    static void main(String[] args) {
        List<Integer> vals = IntStream.range(1, 9)
                .mapToObj({ it })
                .collect(Collectors.toList())

        while (true) {
            Collections.shuffle(vals)
            for (int i = 0; i < pegs.length; i++) {
                pegs[i] = vals.get(i)
            }
            if (solved()) {
                break
            }
        }

        printResult()
    }

    static boolean solved() {
        for (int i = 0; i < links.length; i++) {
            for (int peg : links[i]) {
                if (Math.abs(pegs[i] - peg) == 1) {
                    return false
                }
            }
        }
        return true
    }

    static void printResult() {
        println("  ${pegs[0]} ${pegs[1]}")
        println("${pegs[2]} ${pegs[3]} ${pegs[4]} ${pegs[5]}")
        println("  ${pegs[6]} ${pegs[7]}")
    }
}
