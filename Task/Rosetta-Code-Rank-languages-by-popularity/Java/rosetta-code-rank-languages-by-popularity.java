import  java.net.URL;
import  java.net.URLConnection;
import  java.io.*;
import  java.util.*;

public class GetRCLanguages
{
    // Custom sort Comparator for sorting the language list
    // assumes the first character is the page count and the rest is the language name
    private static class LanguageComparator implements Comparator<String>
    {
        public int compare( String a, String b )
        {
            // as we "know" we will be comparaing languages, we will assume the Strings have the appropriate format
            int result = ( b.charAt( 0 ) - a.charAt( 0 ) );
            if( result == 0 )
            {
                // the counts are the same - compare the names
                result = a.compareTo( b );
            } // if result == 0
        return result;
        } // compare
    } // LanguageComparator

    // get the string following marker in text
    private static String after( String text, int marker )
    {
        String result = "";
        int    pos    = text.indexOf( marker );
        if( pos >= 0 )
        {
            // the marker is in the string
            result = text.substring( pos + 1 );
        } // if pos >= 0
    return result;
    } // after

    // read and parse the content of path
    // results returned in gcmcontinue and languageList
    public static void parseContent( String path
                                   , String[] gcmcontinue
                                   , ArrayList<String> languageList
                                   )
    {
        try
        {

            URL            url = new URL( path );
            URLConnection  rc  = url.openConnection();
            // Rosetta Code objects to the default Java user agant so use a blank one
            rc.setRequestProperty( "User-Agent", "" );
            BufferedReader bfr = new BufferedReader( new InputStreamReader( rc.getInputStream() ) );

            gcmcontinue[0]      = "";
            String languageName = "?";
            String line         = bfr.readLine();
            while( line != null )
            {
                line = line.trim();
                if     ( line.startsWith( "[title]" ) )
                {
                    // have a programming language - should look like "[title] => Category:languageName"
                    languageName = after( line, ':' ).trim();
                }
                else if( line.startsWith( "[pages]" ) )
                {
                    // number of pages the language has (probably)
                    String pageCount = after( line, '>' ).trim();
                    if( pageCount.compareTo( "Array" ) != 0 )
                    {
                        // haven't got "[pages] => Array" - must be a number of pages
                        languageList.add( ( (char) Integer.parseInt( pageCount ) ) + languageName );
                        languageName = "?";
                    } // if [pageCount.compareTo( "Array" ) != 0
                }
                else if( line.startsWith( "[gcmcontinue]" ) )
                {
                    // have an indication of wether there is more data or not
                    gcmcontinue[0] = after( line, '>' ).trim();
                } // if various line starts
                line = bfr.readLine();
            } // while line != null
            bfr.close();
        }
        catch( Exception e )
        {
            e.printStackTrace();
        } // try-catch
    } // parseContent

    public static void main( String[] args )
    {
        // get the languages
        ArrayList<String> languageList = new ArrayList<String>( 1000 );
        String[]          gcmcontinue  = new String[1];
        gcmcontinue[0]                 = "";
        do
        {
            String path = ( "http://www.rosettacode.org/mw/api.php?action=query"
                          + "&generator=categorymembers"
                          + "&gcmtitle=Category:Programming%20Languages"
                          + "&gcmlimit=500"
                          + ( gcmcontinue[0].compareTo( "" ) == 0 ? "" : ( "&gcmcontinue=" + gcmcontinue[0] ) )
                          + "&prop=categoryinfo"
                          + "&format=txt"
                          );
            parseContent( path, gcmcontinue, languageList );
        }
        while( gcmcontinue[0].compareTo( "" ) != 0 );
        // sort the languages
        String[] languages = languageList.toArray(new String[]{});
        Arrays.sort( languages, new LanguageComparator() );
        // print the languages
        int    lastTie    = -1;
        int    lastCount  = -1;
        for( int lPos = 0; lPos < languages.length; lPos ++ )
        {
            int    count = (int) ( languages[ lPos ].charAt( 0 ) );
            System.out.format( "%4d: %4d: %s\n"
                             , 1 + ( count == lastCount ? lastTie : lPos )
                             , count
                             , languages[ lPos ].substring( 1 )
                             );
            if( count != lastCount )
            {
                lastTie   = lPos;
                lastCount = count;
            } // if count != lastCount
        } // for lPos
    } // main
} // GetRCLanguages
