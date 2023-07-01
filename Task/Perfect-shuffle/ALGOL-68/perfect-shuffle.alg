# returns an array of the specified length, initialised to an ascending sequence of integers #
OP   DECK = ( INT length )[]INT:
     BEGIN
         [ 1 : length ]INT result;
         FOR i TO UPB result DO result[ i ] := i OD;
        result
     END # DECK # ;

# in-place shuffles the deck as per the task requirements #
# LWB deck is assumed to be 1 #
PROC shuffle = ( REF[]INT deck )VOID:
     BEGIN
         [ 1 : UPB deck ]INT result;
         INT left pos  := 1;
         INT right pos := ( UPB deck OVER 2 ) + 1;
         FOR i FROM 2 BY 2 TO UPB result DO
             result[ left pos  ] := deck[ i - 1 ];
             result[ right pos ] := deck[ i     ];
             left pos  +:= 1;
             right pos +:= 1
         OD;
         FOR i TO UPB deck DO deck[ i ] := result[ i ] OD
     END # SHUFFLE # ;

# compares two integer arrays for equality #
OP   = = ( []INT a, b )BOOL:
     IF LWB a /= LWB b OR UPB a /= UPB b
     THEN # the arrays have different bounds #
         FALSE
     ELSE
         BOOL result := TRUE;
         FOR i FROM LWB a TO UPB a WHILE result := a[ i ] = b[ i ] DO SKIP OD;
         result
     FI # = # ;

# compares two integer arrays for inequality #
OP   /= = ( []INT a, b )BOOL: NOT ( a = b );

# returns the number of shuffles required to return a deck of the specified length #
# back to its original state #
PROC count shuffles = ( INT length )INT:
     BEGIN
         []            INT original deck  = DECK length;
         [ 1 : length ]INT shuffled deck := original deck;
         INT   count         := 1;
         WHILE shuffle( shuffled deck );
               shuffled deck /= original deck
         DO
             count +:= 1
         OD;
         count
     END # count shuffles # ;

# test the shuffling #
[]INT lengths = ( 8, 24, 52, 100, 1020, 1024, 10 000 );
FOR l FROM LWB lengths TO UPB lengths DO
    print( ( whole( lengths[ l ], -8 ) + ": " + whole( count shuffles( lengths[ l ] ), -6 ), newline ) )
OD
