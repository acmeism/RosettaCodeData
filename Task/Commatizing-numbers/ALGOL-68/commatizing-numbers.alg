# returns text commatized according to the rules of the task and the      #
#         period, location and separator paramters                        #
PROC commatize = ( STRING text, INT location, INT period, STRING separator )STRING:
     IF  STRING str := text[ AT 1 ];
         # handle the options                                             #
         INT    start position   := IF location  = 0  THEN  1  ELSE location  FI;
         INT    period length    := IF period    = 0  THEN  3  ELSE period    FI;
         STRING separator string := IF separator = "" THEN "," ELSE separator FI;
         period length < 1 OR start position < 1 OR start position > UPB str
     THEN
         # invalid parameters - return the text unchanged                 #
         text
     ELIF # attempt to find a non-zero digit                              #
          INT number pos := start position;
          WHILE IF number pos > UPB str
                THEN FALSE
                ELSE str[ number pos ] < "1" OR str[ number pos ] > "9"
                FI
          DO
              number pos +:= 1
          OD;
          number pos > UPB str
     THEN # no digits in the string - return the text unchanged           #
          text
     ELSE # have at least one digit                                       #
          STRING result := str[ 1 : number pos - 1 ];
          # find the final digit                                          #
          INT number end := number pos;
          WHILE IF number end >= UPB str
                THEN FALSE
                ELSE str[ number end + 1 ] >= "0" AND str[ number end + 1 ] <= "9"
                FI
          DO
              number end +:= 1
          OD;
          # copy the digits commatizing as required                       #
          INT   digit count := ( number end - number pos ) + 1;
          WHILE digit count > 1 DO
              result      +:= str[ number pos ];
              number pos  +:= 1;
              digit count -:= 1;
              IF digit count MOD period length = 0 THEN
                  # need a comma after this digit                         #
                  result +:= separator string
              FI
          OD;
          # final digit and the rest of the string                        #
          result +:= str[ number pos : ];
          result
     FI # commatize # ;

# modes and operators to allow us to specify optional parameters to the   #
# commatizing procedure                                                   #
MODE COMMATIZINGOPTIONS = STRUCT( STRING text, INT location, INT period, STRING separator );
PRIO LOCATION  = 9;
OP   LOCATION  = ( STRING text, INT location )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text, location, 0, "" );
PRIO PERIOD    = 9;
OP   PERIOD    = ( STRING text, INT period   )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text, 0, period, "" );
PRIO SEPARATOR = 9;
OP   SEPARATOR = ( STRING text, CHAR   separator )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text, 0, 0, separator );
OP   SEPARATOR = ( STRING text, STRING separator )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text, 0, 0, separator );
OP   LOCATION  = ( COMMATIZINGOPTIONS opts, INT location     )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text OF opts, location, period OF opts, separator OF opts );
OP   PERIOD    = ( COMMATIZINGOPTIONS opts, INT period       )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text OF opts, location OF opts, period, separator OF opts );
OP   SEPARATOR = ( COMMATIZINGOPTIONS opts, CHAR   separator )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text OF opts, location OF opts, period OF opts, separator );
OP   SEPARATOR = ( COMMATIZINGOPTIONS opts, STRING separator )COMMATIZINGOPTIONS:
     COMMATIZINGOPTIONS( text OF opts, location OF opts, period OF opts, separator );
OP   COMMATIZE = ( STRING text             )STRING: commatize( text, 0, 0, "" );
OP   COMMATIZE = ( COMMATIZINGOPTIONS opts )STRING:
     commatize( text OF opts, location OF opts, period OF opts, separator OF opts );

# test the commatization procedure and operators                          #
print( ( COMMATIZE( "pi=3.14159265358979323846264338327950288419716939937510582097494459231"
                    PERIOD 5 SEPARATOR " " LOCATION 6 ), newline ) );
print( ( COMMATIZE( "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."
                    SEPARATOR "." ), newline ) );
print( ( COMMATIZE( "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."
                    SEPARATOR "." PERIOD 6 ), newline ) );
print( ( COMMATIZE( "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."
                    SEPARATOR "__" ), newline ) );
print( ( COMMATIZE( "The author has two Z$100000000000000 Zimbabwe notes (100 trillion)."
                    LOCATION 26 PERIOD 1 SEPARATOR "::" ), newline ) );
print( ( COMMATIZE  """-in Aus$+1411.8millions""", newline ) );
print( ( COMMATIZE  "===US$0017440 millions=== (in 2000 dollars)", newline ) );
print( ( COMMATIZE  "123.e8000 is pretty big.", newline ) );
print( ( COMMATIZE  "The land area of the earth is 57268900(29% of the surface) square miles.", newline ) );
print( ( COMMATIZE  "Ain't no numbers in this here words, nohow, no way, Jose.", newline ) );
print( ( COMMATIZE  "James was never known as 0000000007", newline ) );
print( ( COMMATIZE ( "Arthur Eddington wrote: I believe there are "
                   + "15747724136275002577605653961181555468044717914527116709366231425076185631031296 "
                   + "protons in the universe."
                   ), newline ) );
print( ( COMMATIZE  "   $-140000±100 millions.", newline ) );
print( ( COMMATIZE  "6/9/1946 was a good year for some.", newline ) )
