import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ThreadLocalRandom;

public final class MastermindTask {

	public static void main(String[] aArgs) {
	    Mastermind mastermind = new Mastermind(4, 8, 12, false);
	    mastermind.play();
	}
	
	private static final class Mastermind {
		
	    public Mastermind(int aCodeLength, int aLetterCount, int aGuessCount, boolean aRepeatLetters) {
	        if ( aCodeLength < 4 ) {
	        	aCodeLength = 4;
	        } else if ( aCodeLength > 10 ) {
	        	aCodeLength = 10;
	        }
	
	        if ( aLetterCount < 2 ) {
	        	aLetterCount = 2;
	        } else if ( aLetterCount > 20 ) {
	        	aLetterCount = 20;
	        }
	
	        if ( aGuessCount < 7 ) {
	        	aGuessCount = 7;
	        } else if ( aGuessCount > 20 ) {
	        	aGuessCount = 20;
	        }	
	
	        if ( ! aRepeatLetters && aLetterCount < aCodeLength ) {
	        	aLetterCount = aCodeLength;
	        }
	
	        codeLength = aCodeLength;
	        letterCount = aLetterCount;
	        guessCount = aGuessCount;
	        repeatLetters = aRepeatLetters;

	        String validLetters = "ABCDEFGHIJKLMNOPQRST";
	        letters = "";
	        for ( int i = 0; i < letterCount; i++ ) {
	            letters += validLetters.charAt(i);
	        }
	    }
	
	    public void play() {
	        boolean playerWin = false;
	        goal = createGoal();

	        while ( guessCount > 0 && ! playerWin ) {
	            showBoard();
	            if ( checkUserInput(obtainUserGuess()) ) {
	                playerWin = true;
	                reader.close();
	            }
	            guessCount--;
	        }
	
	        if ( playerWin ) {
	            System.out.println(newLine + newLine + "--------------------------------" + newLine +
	                "Very well done! " + newLine + "You found the code: " + goal +
	                newLine + "--------------------------------" + newLine + newLine);
	        } else {
	            System.out.println(newLine + newLine + "--------------------------------" + newLine +
	                "I'm sorry, you couldn't make it! " + newLine + "The code was: " + goal +
	                newLine + "--------------------------------" + newLine + newLine);
	        }
	    }
	
	    private void showBoard() {
	        for ( int i = 0; i < guesses.size(); i++ ) {
	            System.out.print(newLine + "--------------------------------" + newLine);
	            System.out.print(( i + 1 ) + ": ");
	            for ( char ch : guesses.get(i) ) {
	                System.out.print(ch + " ");
	            }

	            System.out.print(" :  ");
	            for ( char ch : results.get(i) ) {
	                System.out.print(ch + " ");
	            }

	            final int errorCount = codeLength - results.get(i).size();
                for ( int j = 0; j < errorCount; j++ ) {
                	System.out.print("- ");
                }
	        }
	        System.out.print(newLine + newLine);
	    }	
	
	    private String obtainUserGuess() {
	        String result = "";
	        do {
	        	System.out.print("Enter your guess (" + letters + "): ");	
	        	result = reader.nextLine().toUpperCase();
	        	if ( result.length() != codeLength ) {
	        		System.out.println("Please try again, your guess should have " + codeLength + " letters");
	        	}	        	
	        } while ( result.length() != codeLength );	
	        return result;
	    }
	
	    private boolean checkUserInput(String aUserInput) {
	        List<Character> userInputCharacters = new ArrayList<Character>();
	        for ( char ch : aUserInput.toCharArray() ) {
	            userInputCharacters.add(ch);
	        }
	        guesses.add(userInputCharacters);
	
	        int xCount = 0;
	        int oCount = 0;
	        List<Boolean> fullMatches = new ArrayList<Boolean>(Collections.nCopies(codeLength, false));
	        List<Boolean> partialMatches = new ArrayList<Boolean>(Collections.nCopies(codeLength, false));
	
	        for ( int i = 0; i < codeLength; i++ ) {
	            if ( aUserInput.charAt(i) == goal.charAt(i) ) {
	                fullMatches.set(i, true);
	                partialMatches.set(i, true);
	                xCount++;
	            }
	        }
	
	        for ( int i = 0; i < codeLength; i++ ) {
	            if ( fullMatches.get(i) ) {
	            	continue;
	            }
	            for ( int j = 0; j < codeLength; j++ ) {
	                if ( i == j || partialMatches.get(j) ) {
	                	continue;
	                }
	                if ( aUserInput.charAt(i) == goal.charAt(j) ) {
	                    partialMatches.set(j, true);
	                    oCount++;
	                    break;
	                }
	            }
	        }
	
	        List<Character> nextResult = new ArrayList<Character>();
	        for ( int i = 0; i < xCount; i++ ) {
	        	nextResult.add('X');
	        }
	        for ( int i = 0; i < oCount; i++ ) {
	        	nextResult.add('O');
	        }
	        results.add(nextResult);

	        return xCount == codeLength;
	    }
	
	    private String createGoal() {
	        String result = "";
	        String lettersCopy = letters;

	        for ( int i = 0; i < codeLength; i++ ) {
	            final int index = random.nextInt(lettersCopy.length());
	            result += lettersCopy.charAt(index);
	            if ( ! repeatLetters ) {
	            	lettersCopy = lettersCopy.substring(0, index) + lettersCopy.substring(index + 1);
	            }
	        }
	        return result;
	    }
	
	    private int codeLength, letterCount, guessCount;
	    private String letters, goal;
	    private boolean repeatLetters;
	    private Scanner reader = new Scanner(System.in);
	    private List<List<Character>> guesses = new ArrayList<List<Character>>();
	    private List<List<Character>> results = new ArrayList<List<Character>>(); 	
	
	    private final ThreadLocalRandom random = ThreadLocalRandom.current();
	    private final String newLine = System.lineSeparator();
	
	}

}
