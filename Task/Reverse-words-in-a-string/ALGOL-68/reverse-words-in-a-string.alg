# returns original phrase with the order of the words reversed #
# a word is a sequence of non-blank characters                 #
PROC reverse word order = ( STRING original phrase )STRING:
     BEGIN
        STRING words reversed := "";
        STRING separator      := "";
        INT    start pos      := LWB original phrase;
        WHILE
            # skip leading spaces #
            WHILE IF start pos <= UPB original phrase
                  THEN original phrase[ start pos ] = " "
                  ELSE FALSE
                  FI
            DO start pos +:= 1
            OD;
            start pos <= UPB original phrase
        DO
            # have another word, find it #
            INT end pos := start pos;
            WHILE IF end pos <= UPB original phrase
                  THEN original phrase[ end pos ] /= " "
                  ELSE FALSE
                  FI
            DO end pos +:= 1
            OD;
            ( original phrase[ start pos : end pos - 1 ] + separator ) +=: words reversed;
            separator := " ";
            start pos := end pos + 1
        OD;
        words reversed
     END # reverse word order # ;

# reverse the words in the lines as per the task #
print( ( reverse word order ( "--------- Ice and Fire ------------ " ), newline ) );
print( ( reverse word order ( "                                    " ), newline ) );
print( ( reverse word order ( "fire, in end will world the say Some" ), newline ) );
print( ( reverse word order ( "ice. in say Some                    " ), newline ) );
print( ( reverse word order ( "desire of tasted I've what From     " ), newline ) );
print( ( reverse word order ( "fire. favor who those with hold I   " ), newline ) );
print( ( reverse word order ( "                                    " ), newline ) );
print( ( reverse word order ( "... elided paragraph last ...       " ), newline ) );
print( ( reverse word order ( "                                    " ), newline ) );
print( ( reverse word order ( "Frost Robert -----------------------" ), newline ) )
