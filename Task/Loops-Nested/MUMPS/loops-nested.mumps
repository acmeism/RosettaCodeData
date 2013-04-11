NESTLOOP
 ;.../loops/nested
 ;set up the 2D array with random values
 NEW A,I,J,K,FLAG,TRIGGER
 SET K=15 ;Magic - just to give us a size to work with
 SET TRIGGER=20 ;Magic - the max value, and the end value
 FOR I=1:1:K FOR J=1:1:K SET A(I,J)=$RANDOM(TRIGGER)+1
 ;Now, search through the array, halting when the value of TRIGGER is found
 SET FLAG=0
 SET (I,J)=0
 FOR I=1:1:K Q:FLAG  W ! FOR J=1:1:K WRITE A(I,J),$SELECT(J'=K:", ",1:"") SET FLAG=(A(I,J)=TRIGGER) Q:FLAG
 KILL A,I,J,K,FLAG,TRIGGER
 QUIT
