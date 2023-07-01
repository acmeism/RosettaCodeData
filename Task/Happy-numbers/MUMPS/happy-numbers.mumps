ISHAPPY(N)
 ;Determines if a number N is a happy number
 ;Note that the returned strings do not have a leading digit unless it is a happy number
 IF (N'=N\1)!(N<0) QUIT "Not a positive integer"
 NEW SUM,I
 ;SUM is the sum of the square of each digit
 ;I is a loop variable
 ;SEQ is the sequence of previously checked SUMs from the original N
 ;If it isn't set already, initialize it to an empty string
 IF $DATA(SEQ)=0 NEW SEQ SET SEQ=""
 SET SUM=0
 FOR I=1:1:$LENGTH(N) DO
 .SET SUM=SUM+($EXTRACT(N,I)*$EXTRACT(N,I))
 QUIT:(SUM=1) SUM
 QUIT:$FIND(SEQ,SUM)>1 "Part of a sequence not containing 1"
 SET SEQ=SEQ_","_SUM
 QUIT $$ISHAPPY(SUM)
HAPPY(C) ;Finds the first C happy numbers
 NEW I
 ;I is a counter for what integer we're looking at
 WRITE !,"The first "_C_" happy numbers are:"
 FOR I=1:1 QUIT:C<1  SET Q=+$$ISHAPPY(I) WRITE:Q !,I SET:Q C=C-1
 KILL I
 QUIT
