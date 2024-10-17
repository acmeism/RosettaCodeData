# The standard SIGN operator returns -1 if its operand is < 0 #
#                                  ,  0 if its operand is   0 #
#                                  ,  1 if its operand is > 0 #
# This array maps he results of SIGN to FALSE or TRUE for the #
# ATLEASTASLONGAS operator defined below                      #
[ -1 : 1 ]BOOL not shorter;
not shorter[ -1 ] := FALSE;
not shorter[  0 ] := FALSE;
not shorter[  1 ] := TRUE;

# Set the priorities for the dyadic operators defined below   #
# 9 is the highest priority, so a LOMGERTHAN b AND ...        #
# is parsed correctly                                         #
PRIO ATLEASTASLONGAS = 9
   , LONGERTHAN      = 9
   ;


OP   NONEMPTYSTRING  = ( STRING a )STRING: " " + a[ AT 1 ];

# STRING x is at least as long as STRING y if the substring   #
# of x from the upper bound of y to the end of x is at least  #
# one character long                                          #
# Note that Algol 68 doesn't raise an error if the substring  #
# start position is after the upper bound of the string, but  #
# does object if the start position is before the lower bound #
# - hence the need for the NONEMPTYSTRING operator to ensure  #
#   we don't try executing a[ 0 : ] when b is ""              #
OP   ATLEASTASLONGAS = ( STRING x, STRING y )BOOL:
     BEGIN
        STRING a = NONEMPTYSTRING x;
        STRING b = NONEMPTYSTRING y;
        not shorter[ SIGN UPB a[ UPB b : ] ]
     END # ATLEASTASLONGAS # ;

# x is longer than y if x is at least as long as y and        #
# y is not at least as long as x                              #
OP   LONGERTHAN      = ( STRING x, STRING y )BOOL: x ATLEASTASLONGAS y AND NOT ( y ATLEASTASLONGAS x );
# additional LONGERTHAN operators to handle single chatracter #
# STRINGs which are actually CHAR values in Algol 68          #
# Not needed for the task, but useful for testing LONGERTHAN  #
CO OP   LONGERTHAN      = ( CHAR   x, CHAR   y )BOOL: FALSE;
   OP   LONGERTHAN      = ( CHAR   x, STRING y )BOOL: STRING( x ) LONGERTHAN y;
   OP   LONGERTHAN      = ( STRING x, CHAR   y )BOOL: x LONGERTHAN STRING( y );
CO

COMMENT # basic test of LONGERTHAN: # C-MMENT
print( ( "abc" LONGERTHAN "bbcd", "ABC" LONGERTHAN "", "" LONGERTHAN "abc", "DEF" LONGERTHAN "DEF", "abcd" LONGERTHAN "a", newline ) );
C-MMENT COMMENT

PROC read a line = ( REF FILE f )STRING:
     BEGIN
         STRING line;
         get( f, ( line, newline ) );
         IF at eof THEN "" ELSE line FI
     END # read a line # ;

# EOF handler for standard input                              #
BOOL at eof := FALSE;
on logical file end( stand in, ( REF FILE f )BOOL: at eof := TRUE );

# recursively find the longest line(s) in the specified file  #
# and print them                                              #
PROC print longest lines = ( REF FILE f, STRING longest so far )STRING:
     BEGIN
        IF at eof THEN
            longest so far
        ELSE
            STRING s = read a line( f );
            STRING t = IF s LONGERTHAN longest so far
                       THEN
                           print longest lines( f, s )
                       ELSE
                           print longest lines( f, longest so far )
                       FI;
            IF s ATLEASTASLONGAS t AND t ATLEASTASLONGAS s
            THEN
                # this line is as long as the longest          #
                print( ( s, newline ) );
                s
            ELSE
                # shorter line - return the longest            #
                t
            FI
        FI
    END # print longest lines # ;

# find the logest lines from standard inoout                   #
VOID( print longest lines( stand in, read a line( stand in ) ) )
