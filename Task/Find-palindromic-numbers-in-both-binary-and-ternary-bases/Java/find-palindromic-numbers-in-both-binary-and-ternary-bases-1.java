public class Pali23 {
	public static boolean isPali(String x){
		return x.equals(new StringBuilder(x).reverse().toString());
	}
	
	public static void main(String[] args){
		
		for(long i = 0, count = 0; count < 6;i++){
			if((i & 1) == 0 && (i != 0)) continue; //skip non-zero evens, nothing that ends in 0 in binary can be in this sequence
			//maybe speed things up through short-circuit evaluation by putting toString in the if
			//testing up to 10M, base 2 has slightly fewer palindromes so do that one first
			if(isPali(Long.toBinaryString(i)) && isPali(Long.toString(i, 3))){
				System.out.println(i + ", " + Long.toBinaryString(i) + ", " + Long.toString(i, 3));
				count++;
			}
		}
	}
}
