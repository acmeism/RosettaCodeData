import java.util.Arrays;
import java.util.Random;
import java.util.Scanner;
import java.util.stream.IntStream;

public interface PigDice {
  public static void main(String... arguments) {
    final int maxScore = 100;
    final int playerCount = 2;
    final String[] yesses = {"y", "Y", ""};

    final Scanner scanner = new Scanner(System.in);
    final Random random = new Random();

    final int[] safeScore = new int[2];
    final int[] score = new int[2];

    IntStream.iterate(0, player -> (player + 1) % playerCount)
      .map(player -> {
        boolean isRolling = true;
        while (isRolling) {
          System.out.printf(
            "Player %d: (%d, %d) Rolling? (y/n) ",
            player,
            safeScore[player],
            score[player]
          );
          isRolling =
            safeScore[player] + score[player] < maxScore
              && Arrays.asList(yesses).contains(scanner.nextLine())
          ;
          if (isRolling) {
            final int rolled = random.nextInt(6) + 1;
            System.out.printf("Rolled %d\n", rolled);
            if (rolled == 1) {
              System.out.printf(
                "Bust! You lose %d but keep %d\n\n",
                score[player],
                safeScore[player]
              );
              return -1;
            } else {
              score[player] += rolled;
            }
          } else {
            safeScore[player] += score[player];
            if (safeScore[player] >= maxScore) {
              return player;
            }
            System.out.printf("Sticking with %d\n\n", safeScore[player]);
          }
        }
        score[player] = 0;
        return -1;
      })
      .filter(player -> player > -1)
      .findFirst()
      .ifPresent(player ->
        System.out.printf(
          "\n\nPlayer %d wins with a score of %d",
          player,
          safeScore[player]
        )
      )
    ;
  }
}
