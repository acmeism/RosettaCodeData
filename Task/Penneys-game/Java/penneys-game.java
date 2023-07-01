import java.util.*;

public class PenneysGame {

    public static void main(String[] args) {
        Random rand = new Random();

        String compChoice = "", playerChoice;
        if (rand.nextBoolean()) {

            for (int i = 0; i < 3; i++)
                compChoice += "HT".charAt(rand.nextInt(2));
            System.out.printf("Computer chooses %s%n", compChoice);

            playerChoice = prompt(compChoice);

        } else {

            playerChoice = prompt(compChoice);

            compChoice = "T";
            if (playerChoice.charAt(1) == 'T')
                compChoice = "H";
            compChoice += playerChoice.substring(0, 2);
            System.out.printf("Computer chooses %s%n", compChoice);
        }

        String tossed = "";
        while (true) {
            tossed += "HT".charAt(rand.nextInt(2));
            System.out.printf("Tossed %s%n" , tossed);
            if (tossed.endsWith(playerChoice)) {
                System.out.println("You win!");
                break;
            }
            if (tossed.endsWith(compChoice)) {
                System.out.println("Computer wins!");
                break;
            }
        }
    }

    private static String prompt(String otherChoice) {
        Scanner sc = new Scanner(System.in);
        String s;
        do {
            System.out.print("Choose a sequence: ");
            s = sc.nextLine().trim().toUpperCase();
        } while (!s.matches("[HT]{3}") || s.equals(otherChoice));
        return s;
    }
}
