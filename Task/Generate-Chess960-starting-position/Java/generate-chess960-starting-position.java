import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Chess960{
	private static List<Character> pieces = Arrays.asList('R','B','N','Q','K','N','B','R');

	public static List<Character> generateFirstRank(){
		do{
			Collections.shuffle(pieces);
		}while(!check(pieces.toString().replaceAll("[^\\p{Upper}]", ""))); //List.toString adds some human stuff, remove that
		
		return pieces;
	}

	private static boolean check(String rank){
		if(!rank.matches(".*R.*K.*R.*")) return false;			//king between rooks
		if(!rank.matches(".*B(..|....|......|)B.*")) return false;	//all possible ways bishops can be placed
		return true;
	}

	public static void main(String[] args){
		for(int i = 0; i < 10; i++){
			System.out.println(generateFirstRank());
		}
	}
}
