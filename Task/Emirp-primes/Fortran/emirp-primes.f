      MODULE BAG	!A mixed assortment.
       INTEGER MSG	!I/O unit number to share about.
       INTEGER PF16LIMIT,PF32LIMIT,NP			!Know that P(3512) = 32749, the last within two's complement 16-bit integers.
       PARAMETER (PF16LIMIT = 3512, PF32LIMIT = 4793)	!32749² = 1,072,497,001; the integer limit is 2,147,483,647 in 32-bit integers.
       INTEGER*2 PRIME16(PF16LIMIT)			!P(4792) =  46337, next is 46349 and 46337² = 2,147,117,569.
       INTEGER*4 PRIME32(PF16LIMIT + 1:PF32LIMIT)	!Let the compiler track the offsets.
       DATA NP,PRIME16(1),PRIME16(2)/2,2,3/	!But, start off with this. Note that Prime(NP) is odd...
       INTEGER NGP,NNP,NIP	!Invocation counts.
       DATA NGP,NNP,NIP/3*0/	!Starting at zero.
       CONTAINS		!Some co-operating routines.
        RECURSIVE INTEGER FUNCTION GETPRIME(I)	!They are numbered. As if in an array Prime(i).
Chooses from amongst two arrays, of sizes known from previous work.
         INTEGER I		!The desired index.
         INTEGER P		!A potential prime.
         INTEGER MP		!Counts beyond NP.
          NGP = NGP + 1		!Another try.
          IF (I.LE.0) THEN	!A silly question?
            GETPRIME = -666		!This should cause trouble!
          ELSE IF (I.LE.NP) THEN	!I have a little list.
            IF (I.LE.PF16LIMIT) THEN		!Well actually, two little lists.
              GETPRIME = PRIME16(I)		!So, direct access from this.
             ELSE				!Or, for the larger numbers,
              GETPRIME = PRIME32(I)		!This.
            END IF			!So much for previous effort.
          ELSE IF (I.LE.PF32LIMIT) THEN	!My list may not yet be completely filled.
            MP = NP			!This is the last stashed so far.
            P = GETPRIME(NP)		!I'll ask me to figure out where this is stashed.
   10       P = NEXTPRIME(P)		!Go for the next one along.
            MP = MP + 1			!Advance my count.
            IF (MP.LT.I) GO TO 10	!Are we there yet?
            GETPRIME = P		!Yep.
           ELSE			!But, my list may be too short.
            WRITE (MSG,*) "Hic!",I	!So, give an indication.
            STOP "Too far..."		!And quit.
          END IF		!For factoring 32-bit, need only 4792 elements.
        END FUNCTION GETPRIME	!This is probably faster than reading from a monster disc file.

        SUBROUTINE STASHPRIME(P)	!Saves a value in the stash.
         INTEGER P	!The prime to be stashed.
          NP = NP + 1		!Count another in.
          IF (NP.LE.PF16LIMIT) THEN	!But, where to?
            PRIME16(NP) = P			!The short list.
          ELSE IF (NP.LE.PF32LIMIT) THEN!Or,
            PRIME32(NP) = P			!The long list (which is shorter)
          ELSE				!Or,
            STOP "Stash overflow!"		!Oh dear.
          END IF			!It is stashed.
        END SUBROUTINE STASHPRIME	!The checking should be redundant.

        INTEGER FUNCTION FINDPRIME(IT)	!Via binary search.
         INTEGER IT	!The value to be found.
         INTEGER L,R,P	!Assistants.
          L = 0		!This is the *exclusive bounds* version.
          R = NP + 1	!Thus, L = first - 1; R = Last + 1.
    1     P = (R - L)/2		!Probe offset.
          IF (P.LE.0) THEN	!No span?
            FINDPRIME = -L		!Not found. IT follows Prime(L).
            RETURN			!Escape.
          END IF		!But otherwise,
          P = P + L		!Convert to an index into array PRIME, manifested via GETPRIME.
          IF (IT - GETPRIME(P)) 2,4,3	!Compare... Three way result.
    2     R = P; GO TO 1	!IT < PRIME(P): move R back.
    3     L = P; GO TO 1	!PRIME(P) < IT: move L forward.
    4     FINDPRIME = P		!PRIME(P) = IT: Found here!
        END FUNCTION FINDPRIME	!Simple and fast.

        RECURSIVE INTEGER FUNCTION NEXTPRIME(P)	!Some effort may ensue.
Checks the stash in PRIME in the hope of finding the next prime directly, otherwise advances from P.
Collates a stash of primes in PRIME16 and PRIME32, advancing NP from 2 to PF32LIMIT as it goes.
         INTEGER P	!Not necessarily itself a prime number.
         INTEGER PI	!A possibly prime increment.
         INTEGER IT	!A finger.
          NNP = NNP + 1	!Another try
          IF (P.LE.1) THEN	!Dodge annoying effects.	Otherwise, FINDPRIME(P) would be zero.
            PI = 2		!The first prime is known.	Because P precedes Prime(1).
           ELSE			!The first stashed value is two.
            IT = (ABS(FINDPRIME(P)))	!The stash is ordered, and P = 2 will be found at 1.
            IF (IT.LT.NP) THEN		!Before my last-known prime? FINDPRIME(4) = -2 as it follows Prime(NP=2).
              PI = GETPRIME(IT + 1)	!Yes, so I know the next along already.
             ELSE	!Otherwise, it is past Prime(NP). and IT = NP thanks to the ABS.
              IF (NP.LT.PF32LIMIT) THEN	!If my stash is not yet filled,
                PI = GETPRIME(IT)	!I want to start with its last entry, known to be an odd number.
               ELSE			!So that I can stash each next prime along the way.
                PI = P			!Otherwise, start with P.
                IF (MOD(PI,2).EQ.0) PI = PI - 1	!And some suspicion.
              END IF			!So  much for a starting position.
              DO WHILE (PI.LE.P)	!Perhaps I must go further.
   11           PI = PI + 2			!Advance to a possibility.
                IF (.NOT.ISPRIME(PI)) GO TO 11	!Discard it?
                IF (IT.EQ.NP .AND. IT.LT.PF32LIMIT) THEN	!Am I one further on from NP?
                  CALL STASHPRIME(PI)		!Yes, and there is space to stash it.
                  IT = IT + 1			!Ready for the next one along, if it comes.
                END IF			!All are candidates for my stash.
              END DO		!Perhaps this prime will be big enough.
            END IF		!It may be a long way past PRIME(NP).
          END IF		!And I may have filled my stash along the way.
          NEXTPRIME = PI	!Take that.
        END FUNCTION NEXTPRIME	!Messy.

        RECURSIVE LOGICAL FUNCTION ISPRIME(N)	!Checks an arbitrary number, though limited by INTEGER size.
Crunches up to SQRT(N), and at worst needs to be able to reach Prime(4793) = 46349; greater than SQRT(2147483647) = 46340·95...
         INTEGER N	!The number.
         INTEGER I,F,Q	!Assistants.
          NIP = NIP + 1	!Another try.
          IF (N.LT.2) THEN	!Dodge annoyances.
            ISPRIME = .FALSE.	!Such as N = 1, and the first F being 2.
          ELSE			!Otherwise, some effort.
            ISPRIME = .FALSE.	!The usual result.
            I = 1		!Start at the start with PRIME(1).
   10       F = GETPRIME(I)	!Thus, no special case with F = 2.
            Q = N/F		!So, how many times? (Truncation, remember)
            IF (Q .GE. F) THEN	!Q < F means F² > N.
              IF (Q*F .EQ. N) RETURN	!A factor is found!
              I = I + 1		!Very well.
              GO TO 10		!Try the next possible factor.
            END IF		!And if we get through all that,
            ISPRIME = .TRUE.	!It is a prime number.
          END IF		!And we're done.
        END FUNCTION ISPRIME	!After a lot of divisions.

        INTEGER FUNCTION ESREVER(IT,BASE)	!Reversed digits.
         INTEGER IT	!The number to be reversed. Presumably positive.
         INTEGER BASE	!For the numerology.
         INTEGER N,R	!Assistants.
          IF (BASE.LE.1) STOP "Base 2 at least!"	!Ah, distrust.
          N = IT	!A copy I can damage.
          R = 0		!Here we go.
          DO WHILE(N.GT.0)	!A digit remains?
            R = R*BASE + MOD(N,BASE)	!Yes. Grab the low-order digit of N.
            N = N/BASE			!And reduce N by another power of BASE.
          END DO		!Test afresh.
          ESREVER = R		!That's it.
        END FUNCTION ESREVER	!Easy enough.

        SUBROUTINE EMIRP(BASE,N1,N2,I1,I2)	!Two-part interface.
         INTEGER BASE	!Avoid decimalist chauvinism.
         INTEGER N1,N2	!Count span to show those found.
         INTEGER I1,I2	!Search span.
         INTEGER N	!Counter.
         INTEGER P,R	!Assistants.
          WRITE (MSG,1) N1,N2,BASE,I1,I2	!Declare the purpose.
    1     FORMAT ("Show the first ",I0," to ",I0,	!So as to encompass
     &     " emirP numbers (base ",I0,") between ",I0," and ",I0)	!The specified options.
          N = 0		!None found so far.
          P = I1 - 1	!Syncopation. The starting position might itself be a prime number.
Chase another emirP.
   10     P = NEXTPRIME(P)		!I want the next prime.
          IF (P.LT.I1) GO TO 10		!Up to the starting mark yet?
          IF (P.GT.I2) GO TO 900	!Past the finishing mark?
          R = ESREVER(P,BASE)		!Righto, a candidate.
          IF (P .EQ. R) GO TO 10	!Palindromes are rejected.
          IF (.NOT.ISPRIME(R)) GO TO 10	!As are non-primes.
          N = N + 1			!Aha, a success!
c          if (mod(n,100) .eq. 0) then
c            write (6,66) N,P,R,NP,NGP,NNP,NIP
c   66       format ("N=",I5,",p=",I6,",R=",I6,",NP=",I6,3I12)
c          end if
          IF (N.GE.N1) WRITE (6,*) P,R	!Are we within the count span?
          IF (N.LT.N2) GO TO 10		!Past the end?
Closedown.
  900     WRITE (MSG,901) NP,GETPRIME(NP)	!Might be of interest.
  901     FORMAT ("Stashed up to Prime(",I0,") = ",I0,/)
        END SUBROUTINE EMIRP	!Well, that was odd.
      END MODULE BAG	!Mixed.

      PROGRAM POKE	!Now put it all to the test.
      USE BAG		!With ease.
      MSG = 6		!Standard output.

      CALL EMIRP(10,    1,   20,   1,   1000)	!These parameters
      CALL EMIRP(10,    1,   28,7700,   8000)	!Meet the specifiction
      CALL EMIRP(10,10000,10000,   1,1000000)	!Of three separate invocations.

      END	!Whee!
