REGEXP
 NEW HI,W,PATTERN,BOOLEAN
 SET HI="Hello, world!",W="world"
 SET PATTERN=".E1"""_W_""".E"
 SET BOOLEAN=HI?@PATTERN
 WRITE "Source string - '"_HI_"'",!
 WRITE "Partial string - '"_W_"'",!
 WRITE "Pattern string created is - '"_PATTERN_"'",!
 WRITE "Match? ",$SELECT(BOOLEAN:"YES",'BOOLEAN:"No"),!
 ;
 SET BOOLEAN=$FIND(HI,W)
 IF BOOLEAN>0 WRITE $PIECE(HI,W,1)_"string"_$PIECE(HI,W,2)
 QUIT
