import java.util.Random;
import java.util.Scanner;

public class MagicEightBall {

    public static void main(String[] args) {
        new MagicEightBall().run();
    }

    private static String[] ANSWERS = new String[] {"It is certain.", "It is decidedly so.", "Without a doubt.", "Yes - definitely.",
            "You may rely on it.", "As I see it, yes.", "Most likely.", "Outlook good.", "Yes.", "Signs point to yes.",
            "Reply hazy, try again.", "Ask again later.", "Better not tell you now.", "Cannot predict now.", "Concentrate and ask again.",
            "Don't count on it.", "My reply is no.", "My sources say no.", "Outlook not so good.", "Very doubtful. "};

    public void run() {
        Random random = new Random();
        System.out.printf("Hello.  The Magic 8 Ball knows all.  Type your question.%n%n");
        try ( Scanner in = new Scanner(System.in); ) {
            System.out.printf("?  ");
            while ( (in.nextLine()).length() > 0 ) {
                System.out.printf("8 Ball Response:  %s%n", ANSWERS[random.nextInt(ANSWERS.length)]);
                System.out.printf("?  ");
            }
        }
        System.out.printf("%n8 Ball Done.  Bye.");
    }
}
