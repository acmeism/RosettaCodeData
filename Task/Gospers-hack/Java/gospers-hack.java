import java.util.List;
import java.util.function.Function;

public final class GospersHack {

  public static void main(String[] args) {
    Function<Integer, Integer> gospersHack = n -> {
      final int c = n & -n;
      final int r = n + c;
        return ( ( ( r ^ n ) >> 2 ) / c ) | r;
    };

    for ( int start : List.of( 1, 3, 7, 15 ) ) {
        System.out.print(start + ": ");

        for ( int i = 0; i < 10; i++ ) {
            start = gospersHack.apply(start);
            System.out.print(start + " ");
        }
        System.out.println();
    }
  }

}
