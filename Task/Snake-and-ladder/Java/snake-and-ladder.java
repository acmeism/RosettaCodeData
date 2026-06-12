import java.util.Map;
import java.util.Random;

public class Game {
    private static final Map<Integer, Integer> snl = Map.ofEntries(
        Map.entry(4, 14),
        Map.entry(9, 31),
        Map.entry(17, 7),
        Map.entry(20, 38),
        Map.entry(28, 84),
        Map.entry(40, 59),
        Map.entry(51, 67),
        Map.entry(54, 34),
        Map.entry(62, 19),
        Map.entry(63, 81),
        Map.entry(64, 60),
        Map.entry(71, 91),
        Map.entry(87, 24),
        Map.entry(93, 73),
        Map.entry(95, 75),
        Map.entry(99, 78)
    );
    private static final boolean sixesThrowAgain = true;
    private static Random rand = new Random();

    private static int turn(int player, int square) {
        int square2 = square;
        while (true) {
            int roll = rand.nextInt(6) + 1;
            System.out.printf("Player %d, on square %d, rolls a %d", player, square2, roll);
            if (square2 + roll > 100) {
                System.out.println(" but cannot move.");
            } else {
                square2 += roll;
                System.out.printf(" and moves to square %d\n", square2);
                if (square2 == 100) return 100;
                Integer next = snl.getOrDefault(square2, square2);
                if (square2 < next) {
                    System.out.printf("Yay! Landed on a ladder. Climb up to %d.\n", next);
                    if (next == 100) return 100;
                    square2 = next;
                } else if (square2 > next) {
                    System.out.printf("Oops! Landed on a snake. Slither down to %d.\n", next);
                    square2 = next;
                }
            }
            if (roll < 6 || !sixesThrowAgain) return square2;
            System.out.println("Rolled a 6 so roll again.");
        }
    }

    public static void main(String[] args) {
        // three players starting on square one
        int[] players = {1, 1, 1};
        while (true) {
            for (int i = 0; i < players.length; ++i) {
                int ns = turn(i + 1, players[i]);
                if (ns == 100) {
                    System.out.printf("Player %d wins!\n", i + 1);
                    return;
                }
                players[i] = ns;
                System.out.println();
            }
        }
    }
}
