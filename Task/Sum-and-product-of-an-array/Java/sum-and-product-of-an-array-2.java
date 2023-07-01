import java.util.Arrays;

public class SumProd
{
 public static void main(final String[] args)
 {
  int[] arg = {1,2,3,4,5};
  System.out.printf("sum = %d\n", Arrays.stream(arg).sum());
  System.out.printf("sum = %d\n", Arrays.stream(arg).reduce(0, (a, b) -> a + b));
  System.out.printf("product = %d\n", Arrays.stream(arg).reduce(1, (a, b) -> a * b));
 }
}
