import java.util.TreeSet;

public class Farey{
	private static class Frac implements Comparable<Frac>{
		int num;
		int den;
		
		public Frac(int num, int den){
			this.num = num;
			this.den = den;
		}

		@Override
		public String toString(){
			return num + "/" + den;
		}

		@Override
		public int compareTo(Frac o){
			return Double.compare((double)num / den, (double)o.num / o.den);
		}
	}
	
	public static TreeSet<Frac> genFarey(int i){
		TreeSet<Frac> farey = new TreeSet<Frac>();
		for(int den = 1; den <= i; den++){
			for(int num = 0; num <= den; num++){
				farey.add(new Frac(num, den));
			}
		}
		return farey;
	}
	
	public static void main(String[] args){
		for(int i = 1; i <= 11; i++){
			System.out.println("F" + i + ": " + genFarey(i));
		}
		
		for(int i = 100; i <= 1000; i += 100){
			System.out.println("F" + i + ": " + genFarey(i).size() + " members");
		}
	}
}
