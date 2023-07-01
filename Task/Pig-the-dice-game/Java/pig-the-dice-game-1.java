import java.util.*;

public class PigDice {

    public static void main(String[] args) {
        final int maxScore = 100;
        final int playerCount = 2;
        final String[] yesses = {"y", "Y", ""};

        int[] safeScore = new int[2];
        int player = 0, score = 0;

        Scanner sc = new Scanner(System.in);
        Random rnd = new Random();

        while (true) {
            System.out.printf(" Player %d: (%d, %d) Rolling? (y/n) ", player,
                    safeScore[player], score);
            if (safeScore[player] + score < maxScore
                    && Arrays.asList(yesses).contains(sc.nextLine())) {
                final int rolled = rnd.nextInt(6) + 1;
                System.out.printf(" Rolled %d\n", rolled);
                if (rolled == 1) {
                    System.out.printf(" Bust! You lose %d but keep %d\n\n",
                            score, safeScore[player]);
                } else {
                    score += rolled;
                    continue;
                }
            } else {
                safeScore[player] += score;
                if (safeScore[player] >= maxScore)
                    break;
                System.out.printf(" Sticking with %d\n\n", safeScore[player]);
            }
            score = 0;
            player = (player + 1) % playerCount;
        }
        System.out.printf("\n\nPlayer %d wins with a score of %d",
                player, safeScore[player]);
    }
}
