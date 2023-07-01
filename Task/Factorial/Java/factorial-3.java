import java.math.BigInteger;
import java.util.InputMismatchException;
import java.util.Scanner;

public class LargeFactorial {
    public static long userInput;
    public static void main(String[]args){
        Scanner input = new Scanner(System.in);
        System.out.println("Input factorial integer base: ");
        try {
            userInput = input.nextLong();
            System.out.println(userInput + "! is\n" + factorial(userInput) + " using standard factorial method.");
            System.out.println(userInput + "! is\n" + factorialRec(userInput) + " using recursion method.");
        }catch(InputMismatchException x){
            System.out.println("Please give integral numbers.");
        }catch(StackOverflowError ex){
            if(userInput > 0) {
                System.out.println("Number too big.");
            }else{
                System.out.println("Please give non-negative(positive) numbers.");
            }
        }finally {
            System.exit(0);
        }
    }
    public static BigInteger factorialRec(long n){
        BigInteger result = BigInteger.ONE;
        return n == 0 ? result : result.multiply(BigInteger.valueOf(n)).multiply(factorial(n-1));
    }
    public static BigInteger factorial(long n){
        BigInteger result = BigInteger.ONE;
        for(int i = 1; i <= n; i++){
            result = result.multiply(BigInteger.valueOf(i));
        }
        return result;
    }
}
