ERATO1(HI)
 SET HI=HI\1
 KILL ERATO1 ;Don't make it new - we want it to remain after the quit
 NEW I,J,P
 FOR I=2:1:(HI**.5)\1 DO
 .FOR J=I*I:I:HI DO
 ..SET P(J)=1 ;$SELECT($DATA(P(J))#10:P(J)+1,1:1)
 ;WRITE !,"Prime numbers between 2 and ",HI,": "
 FOR I=2:1:HI DO
 .S:'$DATA(P(I)) ERATO1(I)=I ;WRITE $SELECT((I<3):"",1:", "),I
 KILL I,J,P
 QUIT
PRIMDECO(N)
 ;Returns its results in the string PRIMDECO
 ;Kill that before the first call to this recursive function
 QUIT:N<=1
 IF $D(PRIMDECO)=1 SET PRIMDECO="" D ERATO1(N)
 SET N=N\1,I=0
 FOR  SET I=$O(ERATO1(I)) Q:+I<1  Q:'(N#I)
 IF I>1 SET PRIMDECO=$S($L(PRIMDECO)>0:PRIMDECO_"^",1:"")_I D PRIMDECO(N/I)
 ;that is, if I is a factor of N, add it to the string
 QUIT
