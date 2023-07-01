import java.util.*;

public class FWord {
    private /*v*/ String fWord0 = "";
    private /*v*/ String fWord1 = "";

    private String nextFWord () {
        final String result;

        if ( "".equals ( fWord1 ) )      result = "1";
        else if ( "".equals ( fWord0 ) ) result = "0";
        else                             result = fWord1 + fWord0;

        fWord0 = fWord1;
        fWord1 = result;

        return result;
    }

    public static double entropy ( final String source ) {
        final int                        length = source.length ();
        final Map < Character, Integer > counts = new HashMap < Character, Integer > ();
        /*v*/ double                     result = 0.0;

        for ( int i = 0; i < length; i++ ) {
            final char c = source.charAt ( i );

            if ( counts.containsKey ( c ) ) counts.put ( c, counts.get ( c ) + 1 );
            else                            counts.put ( c, 1 );
        }

        for ( final int count : counts.values () ) {
            final double proportion = ( double ) count / length;

            result -= proportion * ( Math.log ( proportion ) / Math.log ( 2 ) );
        }

        return result;
    }

    public static void main ( final String [] args ) {
        final FWord fWord = new FWord ();

        for ( int i = 0; i < 37;  ) {
            final String word = fWord.nextFWord ();

            System.out.printf ( "%3d %10d %s %n", ++i, word.length (), entropy ( word ) );
        }
    }
}
