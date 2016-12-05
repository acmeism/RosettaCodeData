import java.util.Scanner;

public class MatrixArithmetic {
	public static double[][] minor(double[][] a, int x, int y){
		int length = a.length-1;
		double[][] result = new double[length][length];
		for(int i=0;i<length;i++) for(int j=0;j<length;j++){
			if(i<x && j<y){
				result[i][j] = a[i][j];
			}else if(i>=x && j<y){
				result[i][j] = a[i+1][j];
			}else if(i<x && j>=y){
				result[i][j] = a[i][j+1];
			}else{ //i>x && j>y
				result[i][j] = a[i+1][j+1];
			}
		}
		return result;
	}
	public static double det(double[][] a){
		if(a.length == 1){
			return a[0][0];
		}else{
			int sign = 1;
			double sum = 0;
			for(int i=0;i<a.length;i++){
				sum += sign * a[0][i] * det(minor(a,0,i));
				sign *= -1;
			}
			return sum;
		}
	}
	public static double perm(double[][] a){
		if(a.length == 1){
			return a[0][0];
		}else{
			double sum = 0;
			for(int i=0;i<a.length;i++){
				sum += a[0][i] * perm(minor(a,0,i));
			}
			return sum;
		}
	}
	public static void main(String args[]){
		Scanner sc = new Scanner(System.in);
		int size = sc.nextInt();
		double[][] a = new double[size][size];
		for(int i=0;i<size;i++) for(int j=0;j<size;j++){
			a[i][j] = sc.nextDouble();
		}
		sc.close();
		System.out.println("Determinant: "+det(a));
		System.out.println("Permanent: "+perm(a));
	}
}
