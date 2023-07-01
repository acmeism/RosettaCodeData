public abstract class AbstractGuessNumber {

    protected int[] digits;
    private int length;

    public AbstractGuessNumber(int length) {
        this.length = length;
        this.digits = new int[this.length];
    }

    public int[] getDigits() {
        return digits;
    }

    public int getLength() {
        return length;
    }

    public GuessResult match(AbstractGuessNumber guessable) {
        int bulls = 0;
        int cows = 0;

        if (guessable != null) {
            for (int i = 0; i < this.getLength(); i++) {
                for (int j = 0; j < guessable.getLength(); j++) {

                    if (digits[i] == guessable.getDigits()[j]) {
                        if (i == j) {
                            bulls++;
                        } else {
                            cows++;
                        }
                    }
                }
            }
        }
        return new GuessResult(getLength(), bulls, cows);
    }
}
