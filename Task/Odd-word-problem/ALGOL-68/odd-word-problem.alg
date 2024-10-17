BEGIN

    # recursively reverses the current word in the input and returns the    #
    # the character that followed it                                        #
    # "ch" should contain the first letter of the word on entry and will be #
    # updated to the punctuation following the word on exit                 #
    PROC reverse word = ( REF CHAR ch )VOID:
         BEGIN
            CHAR    next ch;
            read( ( next ch ) );
            IF ( next ch <= "Z" AND next ch >= "A" )
            OR ( next ch <= "z" AND next ch >= "a" )
            THEN
                reverse word( next ch )
            FI;
            print( ( ch ) );
            ch := next ch
         END # reverse word # ;

    # recursively prints the current word in the input and returns the      #
    # character that followed it                                            #
    # "ch" should contain the first letter of the word on entry and will be #
    # updated to the punctuation following the word on exit                 #
    PROC normal word = ( REF CHAR ch )VOID:
         IF print( ( ch ) );
            read ( ( ch ) );
            ( ch <= "Z" AND ch >= "A" )
         OR ( ch <= "z" AND ch >= "a" )
         THEN
            normal word( ch )
         FI # normal word # ;

    # read and print words and punctuation from the input stream, reversing #
    # every second word                                                     #
    PROC reverse every other word = VOID:
         BEGIN
            CHAR ch;
            read( ( ch ) );
            WHILE ch /= "." DO
                normal word( ch );
                IF ch /= "." THEN
                    print( ( ch ) );
                    read ( ( ch ) );
                    reverse word( ch )
                FI
            OD;
            print( ( ch ) )
         END; # reverse every other word #

    reverse every other word
END
