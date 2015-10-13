public class Narc{
	public static boolean isNarc(long x){
		if(x < 0) return false;
		
		String xStr = Long.toString(x);
		int m = xStr.length();
		long sum = 0;
		
		for(char c : xStr.toCharArray()){
			sum += Math.pow(Character.digit(c, 10), m);
		}
		return sum == x;
	}

	public static void main(String[] args){
		for(long x = 0, count = 0; count < 25; x++){
			if(isNarc(x)){
				System.out.print(x + " ");
				count++;
			}
		}
	}
}
