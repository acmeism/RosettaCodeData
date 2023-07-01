import java.util.Scanner;

public class Pigdice {

	public static void main(String[] args) {
		Scanner scan = new Scanner(System.in);
		int players = 0;
		
		//Validate the input
		while(true) {
			//Get the number of players
			System.out.println("Hello, welcome to Pig Dice the game! How many players? ");
			if(scan.hasNextInt()) {
				
				//Gotta be more than 0
				int nextInt = scan.nextInt();
				if(nextInt > 0) {
					players = nextInt;
					break;
				}
			}
			else {
				System.out.println("That wasn't an integer. Try again. \n");
				scan.next();
			}
		}
		System.out.println("Alright, starting with " + players + " players. \n");
		
		//Start the game
		play(players, scan);
		
		scan.close();
	}
	
	public static void play(int group, Scanner scan) {
		//Set the number of strategies available.
		final int STRATEGIES = 5;
		
		//Construct the dice- accepts an int as an arg for number of sides, but defaults to 6.
		Dice dice = new Dice();
		
		//Create an array of players and initialize them to defaults.
		Player[] players = new Player[group];
		for(int count = 0; count < group; count++) {
			players[count] = new Player(count);
			System.out.println("Player " + players[count].getNumber() + "  is alive! ");
		}
		
		/*****Print strategy options here. Modify Player.java to add strategies. *****/
		System.out.println("Each strategy is numbered 0 - " + (STRATEGIES - 1) + ". They are as follows: ");
		System.out.println(">> Enter '0' for a human player. ");
		System.out.println(">> Strategy 1 is a basic strategy where the AI rolls until 20+ points and holds unless the current max is 75+.");
		System.out.println(">> Strategy 2 is a basic strategy where the AI, after 3 successful rolls, will randomly decide to roll or hold. ");
		System.out.println(">> Strategy 3 is similar to strategy 2, except it's a little gutsier and will attempt 5 successful rolls. ");
		System.out.println(">> Strategy 4 is like a mix between strategies 1 and 3. After turn points are >= 20 and while max points are still less than 75, it will randomly hold or roll. ");
		
		//Get the strategy for each player
		for(Player player : players) {
			System.out.println("\nWhat strategy would you like player " + player.getNumber() + " to use? ");

			//Validate the strategy is a real strategy.
			while(true) {
				if(scan.hasNextInt()) {
					int nextInt = scan.nextInt();
					if (nextInt < Strategy.STRATEGIES.length) {
						player.setStrategy(Strategy.STRATEGIES[nextInt]);
						break;
					}
				}
				else {
					System.out.println("That wasn't an option. Try again. ");
					scan.next();
				}
			}
		}
		
		//Here is where the rules for the game are programmatically defined.
		int max = 0;
		while(max < 100) {
			
			//Begin the round
			for(Player player : players) {
				System.out.println(">> Beginning Player " + player.getNumber() + "'s turn. ");
				
				//Set the points for the turn to 0
				player.setTurnPoints(0);
				
				//Determine whether the player chooses to roll or hold.
				player.setMax(max);
				while(true) {
					Move choice = player.choose();
					if(choice == Move.ROLL) {
						int roll = dice.roll();
						System.out.println("   A " + roll + " was rolled. ");
						player.setTurnPoints(player.getTurnPoints() + roll);
						
						//Increment the player's built in iterator.
						player.incIter();
						
						//If the player rolls a 1, their turn is over and they gain 0 points this round.
						if(roll == 1) {
							player.setTurnPoints(0);
							break;
						}
					}
					//Check if the player held or not.
					else {
						System.out.println("   The player has held. ");
						break;
					}
				}
				
				//End the turn and add any accumulated points to the player's pool.
				player.addPoints(player.getTurnPoints());
				System.out.println("   Player " + player.getNumber() + "'s turn is now over. Their total is " + player.getPoints() + ". \n");
				
				//Reset the player's built in iterator.
				player.resetIter();
				
				//Update the max score if necessary.
				if(max < player.getPoints()) {
					max = player.getPoints();
				}
				
				//If someone won, stop the game and announce the winner.
				if(max >= 100) {
					System.out.println("Player " + player.getNumber() + " wins with " + max + " points! End scores: ");
					
					//Announce the final scores.
					for(Player p : players) {
						System.out.println("Player " + p.getNumber() + " had " + p.getPoints() + " points. ");
					}
					break;
				}
			}
		}
		
	}
	
}
