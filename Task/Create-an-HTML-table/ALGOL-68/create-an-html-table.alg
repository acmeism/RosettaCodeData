INT not numbered     = 0; # possible values for HTMLTABLE row numbering    #
INT numbered left    = 1; #    "        "    "      "      "      "        #
INT numbered right   = 2; #    "        "    "      "      "      "        #

INT align centre     = 0; # possible values for HTMLTABLE column alignment #
INT align left       = 1; #   "        "    "      "         "       "     #
INT align right      = 2; #   "        "    "      "         "       "     #

# allowable content for the HTML table - extend the UNION and TOSTRING     #
#                                        operator to add additional modes  #
MODE HTMLTABLEDATA   = UNION( INT, REAL, STRING );
OP TOSTRING          = ( HTMLTABLEDATA content )STRING:
    CASE content
      IN ( INT    i ): whole( i, 0 )
       , ( REAL   r ): fixed( r, 0, 0 )
       , ( STRING s ): s
     OUT "Unsupported HTMLTABLEDATA content"
    ESAC;
# MODE to hold an html table                                               #
MODE HTMLTABLE       = STRUCT( FLEX[    0 ]STRING        headings
                             , FLEX[ 0, 0 ]HTMLTABLEDATA data
                             , INT   row numbering
                             , INT   column alignment
                             , INT   cell spacing
                             , INT   col spacing
                             , INT   border
                             );
# write an html table to a file                                            #
PROC write html table = ( REF FILE f, HTMLTABLE t )VOID:
BEGIN
    STRING align = "align="""
                 + CASE column alignment OF t IN "left", "right" OUT "center" ESAC
                 + """";
    PROC th element = ( REF FILE hf, STRING content )VOID:
        put( hf, ( "<th " + align + ">" + content + "</th>", newline ) );
    PROC td element = ( REF FILE hf, HTMLTABLEDATA content )VOID:
        put( hf, ( "<td " + align + ">" + TOSTRING content + "</td>", newline ) );

    # table element #
    put( f, ( "<table"
            + " cellspacing=""" + whole( cell spacing OF t, 0 ) + """"
            +  " colspacing=""" + whole( col spacing  OF t, 0 ) + """"
            +      " border=""" + whole( border       OF t, 0 ) + """"
            + ">"
            , newline
            )
       );
    # table headings                                                       #
    put( f, ( "<tr>", newline ) );
    IF row numbering OF t =  numbered left THEN th element( f, "" ) FI;
    FOR col FROM LWB headings OF t TO UPB headings OF t DO
        th element( f, ( headings OF t )[ col ] )
    OD;
    IF row numbering OF t = numbered right THEN th element( f, "" ) FI;
    put( f, ( "</tr>", newline ) );
    # table rows                                                           #
    FOR row FROM 1 LWB data OF t TO 1 UPB data OF t DO
        put( f, ( "<tr>", newline ) );
        IF row numbering OF t =  numbered left THEN th element( f, whole( row, 0 ) ) FI;
        FOR col FROM 2 LWB data OF t TO 2 UPB data OF t DO
            td element( f, ( data OF t )[ row, col ] )
        OD;
        IF row numbering OF t = numbered right THEN th element( f, whole( row, 0 ) ) FI;
        put( f, ( "</tr>", newline ) )
    OD;
    # end of table                                                         #
    put( f, ( "</table>", newline ) )
END # write html table # ;

BEGIN # tests                                                              #
    # create an HTMLTABLE and print it to standard output                  #
    HTMLTABLE t;
    cell spacing     OF t := col spacing OF t := 0;
    border           OF t := 1;
    column alignment OF t := align right;
    row numbering    OF t := numbered left;
    headings         OF t := ( "A", "B", "C" );
    data             OF t := ( ( 1001, 1002, 1003 ), ( 21, 22, 23 ), ( 201, 202, 203 ) );
    write html table( stand out, t );

    # show the effect of the other alignment and numering options          #
    column alignment OF t := align left;
    row numbering    OF t := numbered right;
    write html table( stand out, t );
    column alignment OF t := align centre;
    row numbering    OF t := not numbered;
    write html table( stand out, t )
END
