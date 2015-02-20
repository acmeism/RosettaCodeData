import java.util.ArrayList;
public class Heron {
	public static void main(String[] args) {
		ArrayList<int[]> list = new ArrayList<int[]>();		
		for(int c = 1; c <= 200; c++){
			for(int b = 1; b <= c; b++){
				for(int a = 1; a <= b; a++){
					if(gcd(gcd(a, b), c) == 1 && isHeron(heronArea(a, b, c)						
						list.add(new int[]{a, b, c, a + b + c, (int)heronArea(a, b, c)});	
				}
			}
		}
		sort(list);	
		System.out.printf("Number of primitive Heronian triangles with sides up to 200: %d\n\nFirst ten when ordered by increasing area, then perimeter:\nSides		Perimeter	Area", list.size());
		for(int i = 0; i < 10; i++){
			System.out.printf("\n%d x %d x %d	%d		%d",list.get(i)[0], list.get(i)[1], list.get(i)[2], list.get(i)[3], list.get(i)[4]);
		}
		System.out.printf("\n\nArea = 210\nSides		Perimeter	Area");
		for(int i = 0; i < list.size(); i++){
			if(list.get(i)[4] == 210)
				System.out.printf("\n%d x %d x %d	%d		%d",list.get(i)[0], list.get(i)[1], list.get(i)[2], list.get(i)[3], list.get(i)[4]);
		}		
	}	
	public static double heronArea(int a, int b, int c){
		double s = (a + b + c)/ 2f;
		return Math.sqrt(s *(s -a)*(s - b)*(s - c));		
	}	
	public static boolean isHeron(double h){
		return h % 1 == 0 && h > 0;
	}	
	public static int gcd(int a, int b){
		int leftover = 1, dividend = a > b ? a : b, divisor = a > b ? b : a;		
		while(leftover != 0){
			leftover = dividend % divisor;
			if(leftover > 0){
				dividend = divisor;
				divisor = leftover;
			}
		}		
		return divisor;
	}
	public static void sort(ArrayList<int[]> list){
		boolean swapped = true;
		int[] temp;
		while(swapped){
			swapped = false;
			for(int i = 1; i < list.size(); i++){
				if(list.get(i)[4] < list.get(i - 1)[4] || list.get(i)[4] == list.get(i - 1)[4] && list.get(i)[3] < list.get(i - 1)[3]){
					temp = list.get(i);
					list.set(i, list.get(i - 1));
					list.set(i - 1, temp);
					swapped = true;
				}				
			}			
		}
	}
}
