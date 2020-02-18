public class BullsAndCowsPlayerGame {

    private static int count;
    private static Console io = System.console();

    private final GameNumber secret;
    private List<AutoGuessNumber> pool = new ArrayList<>();

    public BullsAndCowsPlayerGame(GameNumber secret) {
        this.secret = secret;
        fillPool();
    }

    private void fillPool() {
        for (int i = 123; i < 9877; i++) {
            int[] arr = AutoGuessNumber.parseDigits(i, 4);

            if (GameNumber.isGuess(arr)) {
                pool.add(new AutoGuessNumber(i, 4));
            }
        }
    }

    public void play() {
        io.printf("Bulls and Cows%n");
        io.printf("==============%n");
        io.printf("Secret number is %s%n", secret);

        do {
            AutoGuessNumber guess = guessNumber();
            io.printf("Guess #%d is %s from %d%n", count, guess, pool.size());

            GuessResult result = secret.match(guess);
            if (result != null) {
                printScore(io, result);

                if (result.isWin()) {
                    io.printf("The answer is %s%n", guess);
                    break;
                }

                clearPool(guess, result);
            } else {
                io.printf("No more variants%n");
                System.exit(0);
            }
        } while (true);
    }

    private AutoGuessNumber guessNumber() {
        Random random = new Random();
        if (pool.size() > 0) {
            int number = random.nextInt(pool.size());
            count++;
            return pool.get(number);
        }
        return null;
    }

    private static void printScore(Console io, GuessResult result) {
        io.printf("%1$d  %2$d%n", result.getBulls(), result.getCows());
    }

    private void clearPool(AutoGuessNumber guess, GuessResult guessResult) {
        pool.remove(guess);

        for (int i = 0; i < pool.size(); i++) {
            AutoGuessNumber g = pool.get(i);
            GuessResult gr = guess.match(g);

            if (!guessResult.equals(gr)) {
                pool.remove(g);
            }
        }
    }

    public static void main(String[] args) {
        new BullsAndCowsPlayerGame(new GameNumber()).play();
    }
}
