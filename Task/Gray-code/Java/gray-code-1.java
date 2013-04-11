public class Gray {
	public static long grayEncode(long n){
		return n ^ (n >>> 1);
	}
	
	public static long grayDecode(long n) {
		long p = n;
		while ((n >>>= 1) != 0)
			p ^= n;
		return p;
	}
	public static void main(String[] args){
		System.out.println("i\tBinary\tGray\tDecoded");
		for(int i = -1; i < 32;i++){
			System.out.print(i +"\t");
			System.out.print(Integer.toBinaryString(i) + "\t");
			System.out.print(Long.toBinaryString(grayEncode(i))+ "\t");
			System.out.println(grayDecode(grayEncode(i)));
		}
	}
}
