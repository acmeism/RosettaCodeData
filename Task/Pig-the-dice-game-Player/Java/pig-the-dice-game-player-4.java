import java.util.Scanner;

public interface Strategy {

	Move choose(Player player);
	
	static final Scanner str = new Scanner(System.in);
	static final Dice die = new Dice(2);
	static final int ROOF = 75;
	static final int FLOOR = 20;
	static final int BASEMENT = 10;
	
	/*****MODIFY THIS AREA TO MODIFY THE STRATEGIES*****/
	//Determine whether to roll or hold based on the strategy for this player.
	public static final Strategy[] STRATEGIES = {
		
		//Strategy 0 is a user-defined strategy
		player -> {
			System.out.println("   Your turn points are " + player.getTurnPoints() + ". Your total is " + player.getPoints() + ". ");
			System.out.println("   The max points any player currently has is " + player.getMax() + ". (H)old or (R)oll?");
			System.out.println("   Enter 'h' to hold and 'r' to roll. ");
			while(true) {
				String input = null;
				if(str.hasNextLine()) {
					input = str.nextLine();
				}
				if(input.contains("r")) {
					return Move.ROLL;
				}
				else if(input.contains("h")) {
					return Move.HOLD;
				}
				else {
					System.out.println("  Enter an h or an r. \n");
					System.out.println(input);
				}
			}
		},
		
		//Strategy 1 is a basic strategy where the AI rolls until 20+ points and holds unless the current max is 75+.
		player -> {
			player.aiIntro();
			if(player.getTurnPoints() < FLOOR || player.getMax() >= ROOF) {
				if(player.getTurnPoints() >= (100 - player.getPoints())) {
					return Move.HOLD;					
				}
				else {
					return Move.ROLL;
				}
			}
			else {
				return Move.HOLD;
			}
		},
		
		//Strategy 2 is a basic strategy where the AI, after 3 successful rolls, will randomly decide to roll or hold.
		player -> {
			player.aiIntro();
			if(player.getPoints() == 0 && player.getTurnPoints() >= (BASEMENT / 2)) {
				return Move.HOLD;
			}
			if(player.getIter() > 3) {
				int roll = die.roll();
				
				if(roll == 1) {
					return Move.HOLD;
				}
				else {
					return Move.ROLL;
				}
			}
			else {
				return Move.ROLL;
			}
		},
		
		//Strategy 3 is similar to strategy 2, except it's a little gutsier and will attempt 5 successful rolls.
		player -> {
			player.aiIntro();
			if(player.getIter() > 5) {
				int roll = die.roll();
				
				if(roll == 1) {
					return Move.HOLD;
				}
				else {
					return Move.ROLL;
				}
			}
			else if(player.getPoints() < BASEMENT && player.getTurnPoints() > BASEMENT) {
				return Move.HOLD;
			}
			else {
				return Move.ROLL;
			}
		},
		
		/*Strategy 4 is like a mix between strategies 1 and 3. After turn points are >= 20 and while max points are still less than 75, it will randomly hold or roll.
		Unless their total is zero, in which case they'll hold at 10 points. */
		player -> {
			player.aiIntro();
			if(player.getPoints() == 0 && player.getTurnPoints() >= (BASEMENT / 2)) {
				return Move.HOLD;
			}
			else if(player.getTurnPoints() < FLOOR || player.getMax() >= ROOF) {
				if(player.getTurnPoints() >= (100 - player.getPoints())) {
					return Move.HOLD;					
				}
				else {
					return Move.ROLL;
				}
			}
			else if(player.getTurnPoints() > FLOOR && player.getMax() <= ROOF) {
				int roll = die.roll();
				
				if(roll == 1) {
					return Move.HOLD;
				}
				else {
					return Move.ROLL;
				}
			}
			else {
				return Move.HOLD;
			}
		}
	};

}
