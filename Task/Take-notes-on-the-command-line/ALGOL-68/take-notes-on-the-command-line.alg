BEGIN # display or update NOTES.txt depending on the command line options    #

    PR read "files.incl.a68" PR                     # include file utilities #

    # returns a string representation of v with at least two digits and with #
    #         leading zeros                                                  #
    OP   F = ( INT v )STRING:
         BEGIN
            INT    abs v   = ABS v;
            STRING result := whole( abs v, 0 );
            IF abs v < 10 AND v >= 0 THEN "0" +=: result FI;
            IF v < 0 THEN "-" +=: result FI;
            result
         END # F # ;

    STRING notes file = "NOTES.txt";                        # notes database #
    # check for notes on the command line - ALGOL 68G will expect them to    #
    # follow "--"                                                            #
    INT notes start := 0;
    FOR arg pos FROM 2 TO argc WHILE notes start = 0 DO
        IF argv( arg pos ) = "--" THEN notes start := arg pos FI
    OD;
    IF   notes start = 0 OR notes start = argc
    THEN                     # no command line args, show the existing notes #
         IF   PRINTLINES notes file < 0
         THEN print( ( "Unable to open ", notes file, newline ) )
         FI
    ELSE                          # add a note specified by the command line #
         []INT date = local time[ AT 1 ];
         [ 1 : 3 ]STRING new note;
         new note[ 1 ] :=      F date[ 1 ] + "/" + F date[ 2 ] + "/" + F date[ 3 ]
                        + "."+ F date[ 4 ] + ":" + F date[ 5 ] + ":" + F date[ 6 ];
         new note[ 2 ] := REPR 9 + argv( notes start + 1 );
         FOR arg pos FROM notes start + 2 TO argc DO new note[ 2 ] +:= " " + argv( arg pos ) OD;
         new note[ 3 ] := "";
         IF   NOT ( notes file APPENDLINES new note )
         THEN print( ( "Unable to append the notes", newline ) )
         FI
    FI

END
