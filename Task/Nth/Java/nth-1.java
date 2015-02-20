public class Nth {
	public static String ordinalAbbrev(int n){
		String ans = "th"; //most of the time it should be "th"
		if(n % 100 / 10 == 1) return ans; //teens are all "th"
		switch(n % 10){
			case 1: ans = "st"; break;
			case 2: ans = "nd"; break;
			case 3: ans = "rd"; break;
		}
		return ans;
	}
	
	public static void main(String[] args){
		for(int i = 0; i <= 25;i++){
			System.out.print(i + ordinalAbbrev(i) + " ");
		}
		System.out.println();
		for(int i = 250; i <= 265;i++){
			System.out.print(i + ordinalAbbrev(i) + " ");
		}
		System.out.println();
		for(int i = 1000; i <= 1025;i++){
			System.out.print(i + ordinalAbbrev(i) + " ");
		}
	}
}
