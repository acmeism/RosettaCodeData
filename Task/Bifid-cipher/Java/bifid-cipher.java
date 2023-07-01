import java.awt.Point;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public final class BifidCipher {

	public static void main(String[] aArgs) {
		final String message1 = "ATTACKATDAWN";
		final String message2 = "FLEEATONCE";
		final String message3 = "The invasion will start on the first of January".toUpperCase().replace(" ", "");
		
		Bifid bifid1 = new Bifid(5, "ABCDEFGHIKLMNOPQRSTUVWXYZ");
		Bifid bifid2 = new Bifid(5, "BGWKZQPNDSIOAXEFCLUMTHYVR");
		
		runTest(bifid1, message1);
		runTest(bifid2, message2);
		runTest(bifid2, message1);
		runTest(bifid1, message2);
		
		Bifid bifid3 = new Bifid(6, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789");
		runTest(bifid3, message3);
	}	
	
	private static void runTest(Bifid aBifid, String aMessage) {
		System.out.println("Using Polybius square:");
		aBifid.display();
		System.out.println("Message:   " + aMessage);
		String encrypted = aBifid.encrypt(aMessage);
		System.out.println("Encrypted: " + encrypted);
		String decrypted = aBifid.decrypt(encrypted);
		System.out.println("Decrypted: " + decrypted);
		System.out.println();
	}	
	
}
	
final class Bifid {
	
	public Bifid(int aN, String aText) {
		if ( aText.length() != aN * aN ) {
			throw new IllegalArgumentException("Incorrect length of text");
		}
		
		grid = new char[aN][aN];			
		int row = 0;
		int col = 0;		
		for ( char ch : aText.toCharArray() ) {
		    grid[row][col] = ch;
		    coordinates.put(ch, new Point(row, col) );
		    col += 1;
		    if ( col == aN ) {
		    	col = 0;
		    	row += 1;
		     }
		 }
		
		 if ( aN == 5 ) {
		     coordinates.put('J', coordinates.get('I'));
		 }
	}	
	
	public String encrypt(String aText) {		
		List<Integer> rowOne = new ArrayList<Integer>();
		List<Integer> rowTwo = new ArrayList<Integer>();
		for ( char ch : aText.toCharArray() ) {
			Point coordinate = coordinates.get(ch);
			rowOne.add(coordinate.x);
			rowTwo.add(coordinate.y);
		 }
		
		 rowOne.addAll(rowTwo);
		 StringBuilder result = new StringBuilder();
		 for ( int i = 0; i < rowOne.size() - 1; i += 2 ) {
			 result.append(grid[rowOne.get(i)][rowOne.get(i + 1)]);
		 }
		 return result.toString();
	}
	
	public String decrypt(String aText) {
		List<Integer> row = new ArrayList<Integer>();
		for ( char ch : aText.toCharArray() ) {
			Point coordinate = coordinates.get(ch);
		    row.add(coordinate.x);
		    row.add(coordinate.y);
		}
		
		final int middle = row.size() / 2;
		List<Integer> rowOne = row.subList(0, middle);
		List<Integer> rowTwo = row.subList(middle, row.size());
		StringBuilder result = new StringBuilder();
		for ( int i = 0; i < middle; i++ ) {
			result.append(grid[rowOne.get(i)][rowTwo.get(i)]);
		}
		return result.toString();
	}

    public void display() {
		Arrays.stream(grid).forEach( row -> System.out.println(Arrays.toString(row)) );
	}
	
	private char[][] grid;
	private Map<Character, Point> coordinates = new HashMap<Character, Point>();
	
}
