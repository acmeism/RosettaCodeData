# MODE to hold the compound duration #
MODE DURATION = STRUCT( INT weeks, days, hours, minutes, seconds );

# returns seconds converted to a DURATION #
OP TODURATION = ( LONG INT seconds )DURATION:
   BEGIN
       LONG INT time     := seconds;
       DURATION result   := DURATION( 0, 0, 0, 0, 0 );
       seconds OF result := SHORTEN ( time MOD  60 );
       time OVERAB 60;
       minutes OF result := SHORTEN ( time MOD  60 );
       time OVERAB 60;
       hours   OF result := SHORTEN ( time MOD  24 );
       time OVERAB 24;
       days    OF result := SHORTEN ( time MOD   7 );
       time OVERAB 7;
       weeks   OF result := SHORTEN   time;
       result
   END # DURATION # ;# returns seconds converted to a DURATION #
OP TODURATION = ( INT seconds )DURATION: TODURATION LENG seconds;

# returns a readable form of the DURATION #
OP TOSTRING = ( DURATION t )STRING:
   BEGIN
       STRING result    := "";
       STRING separator := "";
       IF weeks   OF t /= 0 THEN result +:= separator + whole( weeks   OF t, 0 ) + " wk";  separator := ", " FI;
       IF days    OF t /= 0 THEN result +:= separator + whole( days    OF t, 0 ) + " d";   separator := ", " FI;
       IF hours   OF t /= 0 THEN result +:= separator + whole( hours   OF t, 0 ) + " hr";  separator := ", " FI;
       IF minutes OF t /= 0 THEN result +:= separator + whole( minutes OF t, 0 ) + " min"; separator := ", " FI;
       IF seconds OF t /= 0 THEN result +:= separator + whole( seconds OF t, 0 ) + " sec"; separator := ", " FI;
       IF result = ""
       THEN
           # duration is 0 #
           result := "0 sec"
       FI;
       result
   END # TOSTRING # ;

# test cases #
print( ( TOSTRING TODURATION    7259, newline ) );
print( ( TOSTRING TODURATION   86400, newline ) );
print( ( TOSTRING TODURATION 6000000, newline ) )
