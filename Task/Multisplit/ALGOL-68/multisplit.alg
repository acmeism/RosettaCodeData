# split a string based on a number of separators #

# MODE to hold the split results #
MODE SPLITINFO = STRUCT( STRING text      # delimited string, may be empty          #
                       , INT    position  # starting position of the token          #
                       , STRING delimiter # the delimiter that terminated the token #
                       );
# calculates the length of string s #
OP   LENGTH = ( STRING s )INT: ( UPB s + 1 ) - LWB s;
# returns TRUE if s starts with p, FALSE otherwise #
PRIO STARTSWITH = 5;
OP   STARTSWITH = ( STRING s, p )BOOL: IF LENGTH p > LENGTH s THEN FALSE ELSE s[ LWB s : ( LWB s + LENGTH p ) - 1 ] = p FI;
# returns an array of SPLITINFO describing the tokens in str based on the delimiters #
# zero-length delimiters are ignored #
PRIO SPLIT = 5;
OP   SPLIT = ( STRING str, []STRING delimiters )[]SPLITINFO:
     BEGIN
        # count the number of tokens #
        # allow there to be as many tokens as characters in the string + 2 #
        # that would cater for a string composed of delimiters only        #
        [ 1 : ( UPB str + 3 ) - LWB str ]SPLITINFO tokens;
        INT   token count   := 0;
        INT   str pos       := LWB str;
        INT   str max        = UPB str;
        BOOL  token pending := FALSE;
        # construct the tokens #
        str pos       := LWB str;
        INT prev pos  := LWB str;
        token count   := 0;
        token pending := FALSE;
        WHILE str pos <= str max
        DO
            BOOL found delimiter := FALSE;
            FOR d FROM LWB delimiters TO UPB delimiters WHILE NOT found delimiter DO
                IF LENGTH delimiters[ d ] > 0 THEN
                    IF found delimiter := str[ str pos : ] STARTSWITH delimiters[ d ] THEN
                        token count          +:= 1;
                        tokens[ token count ] := ( str[ prev pos : str pos - 1 ], prev pos, delimiters[ d ] );
                        str pos              +:= LENGTH delimiters[ d ];
                        prev pos              := str pos;
                        token pending         := FALSE
                    FI
                FI
            OD;
            IF NOT found delimiter THEN
                # the current character is part of s token #
                token pending := TRUE;
                str pos      +:= 1
            FI
        OD;
        IF token pending THEN
            # there is an additional token after the final delimiter #
            token count +:= 1;
            tokens[ token count ] := ( str[ prev pos : ], prev pos, "" )
        FI;
        # return an array of the actual tokens #
        tokens[ 1 : token count ]
     END # SPLIT # ;


# test the SPLIT operator #
[]SPLITINFO test tokens = "a!===b=!=c" SPLIT []STRING( "==", "!=", "=" );
FOR t FROM LWB test tokens TO UPB test tokens DO
    SPLITINFO token = test tokens[ t ];
    print( ( "token: [",  text OF token, "] at: ", whole( position OF token, 0 ), " delimiter: (", delimiter OF token, ")", newline ) )
OD
