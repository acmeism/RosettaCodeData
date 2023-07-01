import java.util.function.LongUnaryOperator;
import java.util.stream.LongStream;

public class FibUtil {
 public static LongStream fibStream() {
  return LongStream.iterate( 1l, new LongUnaryOperator() {
   private long lastFib = 0;
   @Override public long applyAsLong( long operand ) {
    long ret = operand + lastFib;
    lastFib = operand;
    return ret;
   }
  });
 }
 public static long fib(long n) {
  return fibStream().limit( n ).reduce((prev, last) -> last).getAsLong();
 }
}
