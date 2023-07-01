ERATO1(HI)
 ;performs the Sieve of Erotosethenes up to the number passed in.
 ;This version sets an array containing the primes
 SET HI=HI\1
 KILL ERATO1 ;Don't make it new - we want it to remain after we quit the function
 NEW I,J,P
 FOR I=2:1:(HI**.5)\1 FOR J=I*I:I:HI SET P(J)=1
 FOR I=2:1:HI S:'$DATA(P(I)) ERATO1(I)=I
 KILL I,J,P
 QUIT
