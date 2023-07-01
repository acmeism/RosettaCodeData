CONCOCTED BY R.N.MCLEAN, APPLIED MATHS COURSE, AUCKLAND UNIVERSITY, MCMLXXI.
      INTEGER ENUFF,PRIME(44)
CALCULATION SHOWS PRIME(43) = 181, AND PRIME(44) = 191.
      INTEGER N,F,Q,XP2
      INTEGER INC,IP,LP,PP
      INTEGER ALINE(20),LL,I
      DATA ENUFF/44/
      DATA PP/4/
      DATA PRIME(1),PRIME(2),PRIME(3),PRIME(4)/1,2,3,5/
COPY THE KNOWN PRIMES TO THE OUTPUT LINE.
      DO 1 I = 1,PP
    1   ALINE(I) = PRIME(I)
      LL = PP
      LP = 3
      XP2 = PRIME(LP + 1)**2
      N = 5
      INC = 4
CONSIDER ANOTHER CANDIDATE. VIA INC, DODGE MULTIPLES OF 2 AND 3.
   10 INC = 6 - INC
      N = N + INC
      IF (N - XP2) 20,11,20
   11 LP = LP + 1
      XP2 = PRIME(LP + 1)**2
      GO TO 40
CHECK SUCCESSIVE PRIMES AS FACTORS, STARTING WITH PRIME(4) = 5.
   20 IP = 4
   21 F = PRIME(IP)
      Q = N/F
      IF (Q*F - N) 22,40,22
   22 IP = IP + 1
      IF (IP - LP) 21,21,30
CAUGHT ANOTHER PRIME.
   30 IF (PP - ENUFF) 31,32,32
   31 PP = PP + 1
      PRIME(PP) = N
   32 IF (LL - 20) 35,33,33
   33 WRITE (6,34) (ALINE(I), I = 1,LL)
   34 FORMAT (20I6)
      LL = 0
   35 LL = LL + 1
      ALINE(LL) = N
COMPLETED?
   40 IF (N - 32767) 10,41,41
   41 WRITE (6,34) (ALINE(I), I = 1,LL)
      END