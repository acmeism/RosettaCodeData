import java.util.ArrayList;
import java.util.List;

public class Ludic{
	public static List<Integer> ludicUpTo(int n){
		List<Integer> ludics = new ArrayList<Integer>(n);
		for(int i = 1; i <= n; i++){   //fill the initial list
			ludics.add(i);
		}
		
		//start at index 1 because the first ludic number is 1 and we don't remove anything for it
		for(int cursor = 1; cursor < ludics.size(); cursor++){
			int thisLudic = ludics.get(cursor); //the first item in the list is a ludic number
			int removeCursor = cursor + thisLudic; //start removing that many items later
			while(removeCursor < ludics.size()){
				ludics.remove(removeCursor);		     //remove the next item
				removeCursor = removeCursor + thisLudic - 1; //move the removal cursor up as many spaces as we need to
									     //then back one to make up for the item we just removed
			}
		}
		return ludics;
	}
	
	public static List<List<Integer>> getTriplets(List<Integer> ludics){
		List<List<Integer>> triplets = new ArrayList<List<Integer>>();
		for(int i = 0; i < ludics.size() - 2; i++){ //only need to check up to the third to last item
			int thisLudic = ludics.get(i);
			if(ludics.contains(thisLudic + 2) && ludics.contains(thisLudic + 6)){
				List<Integer> triplet = new ArrayList<Integer>(3);
				triplet.add(thisLudic);
				triplet.add(thisLudic + 2);
				triplet.add(thisLudic + 6);
				triplets.add(triplet);
			}
		}
		return triplets;
	}
	
	public static void main(String[] srgs){
		System.out.println("First 25 Ludics: " + ludicUpTo(110));				//110 will get us 25 numbers
		System.out.println("Ludics up to 1000: " + ludicUpTo(1000).size());
		System.out.println("2000th - 2005th Ludics: " + ludicUpTo(22000).subList(1999, 2005));  //22000 will get us 2005 numbers
		System.out.println("Triplets up to 250: " + getTriplets(ludicUpTo(250)));
	}
}
