import java.util.Arrays;

public class Ulam{
	enum Direction{
		RIGHT, UP, LEFT, DOWN;
	}
	
	private static String[][] genUlam(int n){
		return genUlam(n, 1);
	}

	private static String[][] genUlam(int n, int i){
		String[][] spiral = new String[n][n];
		Direction dir = Direction.RIGHT;
		int j = i;
		int y = n / 2;
		int x = (n % 2 == 0) ? y - 1 : y; //shift left for even n's
		while(j <= ((n * n) - 1 + i)){
			spiral[y][x] = isPrime(j) ? String.format("%4d", j) : " ---";

			switch(dir){
			case RIGHT:
				if(x <= (n - 1) && spiral[y - 1][x] == null && j > i) dir = Direction.UP; break;
			case UP:
				if(spiral[y][x - 1] == null) dir = Direction.LEFT; break;
			case LEFT:
				if(x == 0 || spiral[y + 1][x] == null) dir = Direction.DOWN; break;
			case DOWN:
				if(spiral[y][x + 1] == null) dir = Direction.RIGHT; break;
			}
			
			switch(dir){
				case RIGHT:	x++; break;
				case UP: 	y--; break;
				case LEFT:	x--; break;
				case DOWN:	y++; break;
			}
			j++;
		}
		return spiral;
	}
	
	public static boolean isPrime(int a){
		   if(a == 2) return true;
		   if(a <= 1 || a % 2 == 0) return false;
		   long max = (long)Math.sqrt(a);
		   for(long n = 3; n <= max; n += 2){
		      if(a % n == 0) return false;
		   }
		   return true;
		}
	
	public static void main(String[] args){
		String[][] ulam = genUlam(9);
		for(String[] row : ulam){
			System.out.println(Arrays.toString(row).replaceAll(",", ""));
		}
		System.out.println();
		
		for(String[] row : ulam){
			System.out.println(Arrays.toString(row).replaceAll("\\[\\s+\\d+", "[  * ").replaceAll("\\s+\\d+", "   * ").replaceAll(",", ""));
		}
	}
}
