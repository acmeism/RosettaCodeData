public class Printing{
	public static void main(String[] args){
		double value = 7.125;
		System.out.printf("%09.3f",value); // System.out.format works the same way
		System.out.println(String.format("%09.3f",value));
	}
}
