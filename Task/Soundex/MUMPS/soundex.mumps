SOUNDEX(X,NARA=0)
 ;Converts a string to its Soundex value.
 ;Empty strings return "0000". Non-alphabetic ASCII characters are ignored.
 ;X is the name to be converted to Soundex
 ;NARA is a flag, defaulting to zero, for which implementation to perform.
 ;If NARA is 0, do what seems to be the Knuth implementation
 ;If NARA is a positive integer, do the NARA implementation.
 ; This varies the soundex rule for "W" and "H", and adds variants for prefixed names separated by carets.
 ; http://www.archives.gov/publications/general-info-leaflets/55-census.html
 ;Y is the string to be returned
 ;UP is the list of upper case letters
 ;LO is the list of lower case letters
 ;PREFIX is a list of prefixes to be stripped off
 ;X1 is the upper case version of X
 ;X2 is the name without a prefix
 ;Y2 is the soundex of a name without a prefix
 ;C is a loop variable
 ;DX is a list of Soundex values, in alphabetical order. Underscores are used for the NARA variation letters
 ;XD is a partially processed translation of X into soundex values
 NEW Y,UP,LO,PREFIX,X1,X2,Y2,C,DX,XD
 SET UP="ABCDEFGHIJKLMNOPQRSTUVWXYZ" ;Upper case characters
 SET LO="abcdefghijklmnopqrstuvwxyz" ;Lower case characters
 SET DX=" 123 12_ 22455 12623 1_2 2" ;Soundex values
 SET PREFIX="VAN^CO^DE^LA^LE" ;Prefixes that could create an alternate soundex value
 SET Y="" ;Y is the value to be returned
 SET X1=$TRANSLATE(X,LO,UP) ;Make local copy, and force all letters to be upper case
 SET XD=$TRANSLATE(X1,UP,DX) ;Soundex values for string
 ;
 SET Y=$EXTRACT(X1,1,1) ;Get first character
 FOR C=2:1:$LENGTH(X1) QUIT:$L(Y)>=4  DO
 . ;ignore doubled letters OR and side-by-side soundex values OR same soundex on either side of "H" or "W"
 . QUIT:($EXTRACT(X1,C,C)=$EXTRACT(X1,C-1,C-1))
 . QUIT:($EXTRACT(XD,C,C)=$EXTRACT(XD,C-1,C-1))
 . ;ignore non-alphabetic characters
 . QUIT:UP'[($EXTRACT(X1,C,C))
 . QUIT:NARA&(($EXTRACT(XD,C-1,C-1)="_")&(C>2))&($EXTRACT(XD,C,C)=$EXTRACT(XD,C-2,C-2))
 . QUIT:" _"[$EXTRACT(XD,C,C)
 . SET Y=Y_$EXTRACT(XD,C,C)
 ; Pad with "0" so string length is 4
 IF $LENGTH(Y)<4 FOR C=$L(Y):1:3 SET Y=Y_"0"
 IF NARA DO
 . FOR C=1:1:$LENGTH(PREFIX,"^") DO
 . . IF $EXTRACT(X1,1,$LENGTH($PIECE(PREFIX,"^",C)))=$PIECE(PREFIX,"^",C) DO
 . . . ;Take off the prefix, and any leading spaces
 . . . SET X2=$EXTRACT(X1,$LENGTH($PIECE(PREFIX,"^",C))+1,$LENGTH(X1)-$PIECE(PREFIX,"^",C)) FOR  QUIT:UP[$E(X2,1,1)  SET X2=$E(X2,2,$L(X2))
 . . . SET Y2=$$SOUNDEX(X2,NARA) SET Y=Y_"^"_Y2
 KILL UP,LO,PREFIX,X1,X2,Y2,C,DX,XD
 QUIT Y
