import java.util.Random;

public class Dice {
	Random rand = new Random();
	int sides;
	Dice(int numSides) {
		sides = numSides;
	}
	Dice() {
		sides = 6;
	}
	int roll() {
		return rand.nextInt(sides) + 1;
	}
}
