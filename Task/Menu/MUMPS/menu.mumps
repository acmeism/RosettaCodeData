MENU(STRINGS,SEP)
 ;http://rosettacode.org/wiki/Menu
 NEW I,A,MAX
 ;I is a loop variable
 ;A is the string read in from the user
 ;MAX is the number of substrings in the STRINGS list
 ;SET STRINGS="fee fie^huff and puff^mirror mirror^tick tock"
 SET MAX=$LENGTH(STRINGS,SEP)
 QUIT:MAX=0 ""
WRITEMENU
 FOR I=1:1:MAX WRITE I,": ",$PIECE(STRINGS,SEP,I),!
 READ:30 !,"Choose a string by its index: ",A,!
 IF (A<1)!(A>MAX)!(A\1'=A) GOTO WRITEMENU
 KILL I,MAX
 QUIT $PIECE(STRINGS,SEP,A)
