      INTEGER*8 FUNCTION SUMI(N)	!Sums the integers 1 to N inclusive.
Calculates as per the young Gauss: N*(N + 1)/2 = 1 + 2 + 3 + ... + N.
       INTEGER*8 N	!The number. Possibly large.
        IF (MOD(N,2).EQ.0) THEN	!So, I'm worried about overflow with N*(N + 1)
          SUMI = N/2*(N + 1)		!But since N is even, N/2 is good.
         ELSE			!Otherwise, if N is odd,
          SUMI = (N + 1)/2*N		!(N + 1) must be even.
        END IF			!Either way, the /2 reduces the result.
      END FUNCTION SUMI		!So overflow of intermediate results is avoided.

      INTEGER*8 FUNCTION SUMF(N,F)	!Sum of numbers up to N divisible by F.
       INTEGER*8 N,F		!The selection.
       INTEGER*8 L		!The last in range. N itself is excluded.
       INTEGER*8 SUMI		!Known type of the function.
        L = (N - 1)/F		!Truncates fractional parts.
        SUMF = F*SUMI(L)	!3 + 6 + 9 + ... = 3(1 + 2 + 3 + ...)
      END FUNCTION SUMF		!Could just put SUMF = F*SUMI((N - 1)/F).

      INTEGER*8 FUNCTION SUMBFI(N)	!Brute force and ignorance summation.
       INTEGER*8 N	!The number.
       INTEGER*8 I,S	!Stepper and counter.
        S = 0		!So, here we go.
        DO I = 3,N - 1	!N itself is not a candidate.
          IF (MOD(I,3).EQ.0 .OR. MOD(I,5).EQ.0) S = S + I	!Whee!
        END DO		!On to the next.
        SUMBFI = S		!The result.
      END FUNCTION SUMBFI	!Oh well, computers are fast these days.

      INTEGER*8 SUMF,SUMBFI	!Known type of the function.
      INTEGER*8 N	!The number.
      WRITE (6,*) "Sum multiples of 3 and 5 up to N"
   10 WRITE (6,11)		!Ask nicely.
   11 FORMAT ("Specify N: ",$)	!Obviously, the $ says 'stay on this line'.
      READ (5,*) N		!If blank input is given, further input will be requested.
      IF (N.LE.0) STOP		!Good enough.
      WRITE (6,*) "By Gauss:",SUMF(N,3) + SUMF(N,5) - SUMF(N,15)
      WRITE (6,*) "BFI sum :",SUMBFI(N)		!This could be a bit slow.
      GO TO 10			!Have another go.
      END	!So much for that.
