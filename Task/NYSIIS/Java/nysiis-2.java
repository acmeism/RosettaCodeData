import org.apache.commons.codec.language.Nysiis;
public class nysiisUsingApache
{
    /** NYSIIS codec that wiil allow strings longer than 6 characters
      * to be generated
      */
    private static Nysiis codec = new Nysiis( false );

    /** Encodes name using the codec and checks the result is encoded.
      */
    private static void test( String name, String encoded )
    {
        String result = (String) codec.encode( name );
        System.out.print( String.format( "%16s", name ) + " -> " + result );
        if( result.compareTo( encoded ) != 0 )
        {
            System.out.print( " -- expected \"" + encoded + "\"" );
        } // if result.compareTo( encoded ) != 0
        System.out.println();
    } // test

    public static void main( String[] args )
    {
        test(      "Bishop", "BASAP"    );
        test(     "Carlson", "CARLSAN"  );
        test(        "Carr", "CAR"      );
        test(     "Chapman", "CAPNAN"   );
        test(    "Franklin", "FRANCLAN" );
        test(      "Greene", "GRAN"     );
        test(      "Harper", "HARPAR"   );
        test(      "Jacobs", "JACAB"    );
        test(      "Larson", "LARSAN"   );
        test(    "Lawrence", "LARANC"   );
        test(      "Lawson", "LASAN"    );
        test(  "Louis, XVI", "LASXV"    );
        test(       "Lynch", "LYNC"     );
        test(   "Mackenzie", "MCANSY"   );
        test(    "Matthews", "MAT"      );
        test(   "McCormack", "MCARNAC"  );
        test(    "McDaniel", "MCDANAL"  );
        test(    "McDonald", "MCDANALD" );
        test(  "Mclaughlin", "MCLAGLAN" );
        test(    "Morrison", "MARASAN"  );
        test(    "O'Banion", "OBANAN"   );
        test(     "O'Brien", "OBRAN"    );
        test(    "Richards", "RACARD"   );
        test(       "Silva", "SALV"     );
        test(     "Watkins", "WATCAN"   );
        test(     "Wheeler", "WALAR"    );
        test(      "Willis", "WAL"      );
        test(   "brown, sr", "BRANSR"   );
        test( "browne, III", "BRAN"     );
        test(  "browne, IV", "BRANAV"   );
        test(       "hayes", "HAY"      );
        test(      "knight", "NAGT"     );
        test(    "mitchell", "MATCAL"   );
        test(    "o'daniel", "ODANAL"   );
    } // main
} // nysiisUsingApache
