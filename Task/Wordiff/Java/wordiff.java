import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

public final class Wordiff {

	public static void main(String[] args) throws IOException {
		List<String> dictionary = Files.lines(Path.of("unixdict.txt")).toList();
		List<String> starters = dictionary.stream()
			.filter( word -> word.length() == 3 || word.length() == 4 ).collect(Collectors.toList());
		Collections.shuffle(starters);
		List<String> wordsUsed = new ArrayList<String>();
		wordsUsed.add(starters.get(0));		
		
		Scanner scanner = new Scanner(System.in);
		List<String> playerNames = requestPlayerNames(scanner);		
		boolean playing = true;
		int playerIndex = 0;
		System.out.println("The first word is: " + wordsUsed.get(wordsUsed.size() -  1));		
		
		while ( playing ) {			
			System.out.println(playerNames.get(playerIndex) + " enter your word: ");
			String currentWord = scanner.nextLine();
			if ( isWordiff(currentWord, wordsUsed, dictionary) ) {
				wordsUsed.add(currentWord);
				playerIndex = ( playerIndex == 0 ) ? 1 : 0;
			} else {
				System.out.println("You have lost the game, " + playerNames.get(playerIndex));
				System.out.println("You could have entered: " + couldHaveEntered(wordsUsed, dictionary));
				playing = false;
			}			
		}
		scanner.close();
	}	
	
	private static boolean isWordiff(String currentWord, List<String> wordsUsed, List<String> dictionary) {
		if ( ! dictionary.contains(currentWord) || wordsUsed.contains(currentWord) ) {
			return false;
		}
	
		String previousWord = wordsUsed.get(wordsUsed.size() - 1);
		return isLetterChanged(previousWord, currentWord)
			|| isLetterRemoved(previousWord, currentWord) || isLetterAdded(previousWord, currentWord);
	}
	
	private static boolean isLetterRemoved(String previousWord, String currentWord) {
		for ( int i = 0; i < previousWord.length(); i++ ) {
		    if ( currentWord.equals(previousWord.substring(0, i) + previousWord.substring(i + 1)) ) {
		    	return true;
		    }
		}
		return false;
	}
	
	private static boolean isLetterAdded(String previousWord, String currentWord) {
		return isLetterRemoved(currentWord, previousWord);
	}

	private static boolean isLetterChanged(String previousWord, String currentWord) {
		if ( previousWord.length() != currentWord.length() ) {
			return false;
		}
		
		int differenceCount = 0;
		for ( int i = 0; i < currentWord.length(); i++ ) {
		    differenceCount += ( currentWord.charAt(i) == previousWord.charAt(i) ) ? 0 : 1;
		}
		return differenceCount == 1;
	}	
	
	private static List<String> couldHaveEntered(List<String> wordsUsed, List<String> dictionary) {
		List<String> result = new ArrayList<String>();		
	    for ( String word : dictionary ) {
		    if ( ! wordsUsed.contains(word) && isWordiff(word, wordsUsed, dictionary) ) {
		        result.add(word);
		    }
	    }
	    return result;
	}
	
	private static List<String> requestPlayerNames(Scanner scanner) {
		List<String> playerNames = new ArrayList<String>();
		for ( int i = 0; i < 2; i++ ) {
			System.out.print("Please enter the player's name: ");	
			String playerName = scanner.nextLine().trim();
			playerNames.add(playerName);
		}
	    return playerNames;
	}

}
