import java.util.List;
import java.util.stream.IntStream;

public final class SENDplusMOREequalsMONEY {

	public static void main(String[] args) {
		final int m = 1;
		IntStream.range(8, 10).forEach( s -> {
			IntStream.range(0, 10).forEach( e -> {
				if ( List.of ( m, s ).contains(e) ) { return; }
				IntStream.range(0, 10).forEach( n -> {
					if ( List.of( m, s, e ).contains(n) ) { return; }
					IntStream.range(0, 10).forEach( d -> {
						if ( List.of( m, s, e, n ).contains(d) ) { return; }					
						IntStream.range(0, 10).forEach( o -> {
							if ( List.of( s, e, n, d, m ).contains(o) ) { return; }
							IntStream.range(0, 10).forEach( r -> {
								if ( List.of( s, e, n, d, m, o ).contains(r) ) { return; }
								IntStream.range(0, 10).forEach( y -> {
									if ( List.of( s, e, n, d, m, o ).contains(y) ) { return; }
									if ( 1_000 * s + 100 * e + 10 * n + d + 1_000 * m + 100 * o + 10 * r + e
										== 10_000 * m + 1_000 * o + 100 * n + 10 * e + y ) {
										System.out.println("%d%d%d%d + %d%d%d%d = %d%d%d%d%d"
											.formatted(s, e, n, d, m, o, r, e, m, o, n, e, y));
									}
								} );
							} );
						} );
					} );
				} );
			} );
		} );
	}

}
