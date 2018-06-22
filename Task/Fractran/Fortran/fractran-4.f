       MODULE CONWAYSIDEA	!Notion devised by J. H. Conway.
       USE PRIMEBAG		!This is a common need.
       INTEGER LASTP,ENUFF	!Some size allowances.
       PARAMETER (LASTP = 66, ENUFF = 66)	!Should suffice for the example in mind.
       INTEGER NPPOW(1:LASTP)	!Represent N as a collection of powers of prime numbers.
       TYPE FACTORED		!But represent P and Q of freaction = P/Q
        INTEGER PNUM(0:LASTP)	!As a list of prime number indices with PNUM(0) the count.
        INTEGER PPOW(LASTP)	!And the powers. for the fingered primes.
       END TYPE FACTORED	!Rather than as a simple number multiplied out.
       TYPE(FACTORED) FP(ENUFF),FQ(ENUFF)	!Thus represent a factored fraction, P(i)/Q(i).
       INTEGER PLIVE(ENUFF),NL	!Helps subroutine SHOWN display NPPOW.
       CONTAINS		!Now for the details.
        SUBROUTINE SHOWFACTORS(N)	!First, to show an internal data structure.
         TYPE(FACTORED) N	!It is supplied as a list of prime factors.
         INTEGER I		!A stepper.
          DO I = 1,N.PNUM(0)	!Step along the list.
            IF (I.GT.1) WRITE (MSG,"('x',$)")	!Append a glyph for "multiply".
            WRITE (MSG,"(I0,$)") PRIME(N.PNUM(I))	!The prime fingered in the list.
            IF (N.PPOW(I).GT.1) WRITE (MSG,"('^',I0,$)") N.PPOW(I)	!With an interesting power?
          END DO		!On to the next element in the list.
          WRITE (MSG,1) N.PNUM(0)	!End the line
    1     FORMAT (": Factor count ",I0)	!With a count of prime factors.
        END SUBROUTINE SHOWFACTORS	!Hopefully, this will not be needed often.

        TYPE(FACTORED) FUNCTION FACTOR(IT)	!Into a list of primes and their powers.
         INTEGER IT,N	!The number and a copy to damage.
         INTEGER P,POW	!A stepper and a power.
         INTEGER F,NF	!A factor and a counter.
          IF (IT.LE.0) STOP "Factor only positive numbers!"	!Or else...
          N = IT	!A copy I can damage.
          NF = 0	!No factors found.
          P = 0		!Because no primes have been tried.
       PP:DO WHILE (N.GT.1)	!Step through the possibilities.
       	    P = P + 1		!Another prime impends.
            F = PRIME(P)	!Grab a possible factor.
            POW = 0		!It has no power yet.
         FP:DO WHILE(MOD(N,F).EQ.0)	!Well?
              POW = POW + 1			!Count a factor..
              N = N/F				!Reduce the number.
            END DO FP			!The P'th prime's power's produced.
            IF (POW.GT.0) THEN	!So, was it a factor?
              IF (NF.GE.LASTP) THEN	!Yes. Have I room in the list?
                WRITE (MSG,1) IT,LASTP	!Alas.
    1           FORMAT ("Factoring ",I0," but with provision for only ",
     1           I0," prime factors!")
                FACTOR.PNUM(0) = NF	!Place the count so far,
                CALL SHOWFACTORS(FACTOR)!So this can be invoked.
                STOP "Not enough storage!"	!Quite.
              END IF			!But normally,
              NF = NF + 1		!Admit another factor.
              FACTOR.PNUM(NF) = P	!Identify the prime. NOT the prime itself.
              FACTOR.PPOW(NF) = POW	!Place its power.
            END IF		!So much for that factor.
          END DO PP	!Try another prime, if N > 1 still.
          FACTOR.PNUM(0) = NF	!Place the count.
        END FUNCTION FACTOR	!Thus, a list of primes and their powers.

        INTEGER FUNCTION GCD(I,J)	!Greatest common divisor.
         INTEGER I,J	!Of these two integers.
         INTEGER N,M,R	!Workers.
          N = MAX(I,J)	!Since I don't want to damage I or J,
          M = MIN(I,J)	!These copies might as well be the right way around.
    1     R = MOD(N,M)		!Divide N by M to get the remainder R.
          IF (R.GT.0) THEN	!Remainder zero?
            N = M			!No. Descend a level.
            M = R			!M-multiplicity has been removed from N.
            IF (R .GT. 1) GO TO 1	!No point dividing by one.
          END IF			!If R = 0, M divides N.
          GCD = M			!There we are.
        END FUNCTION GCD	!Euclid lives on!

        INTEGER FUNCTION FRACTRAN(L)	!Applies Conway's idea to a list of fractions.
Could abandon all parameters since global variables have the details...
         INTEGER L	!The last fraction to consider.
         INTEGER I,NF	!Assistants.
          DO I = 1,L		!Step through the fractions in the order they were given.
            NF = FQ(I).PNUM(0)	!How many factors are listed in FQ(I)?
            IF (ALL(NPPOW(FQ(I).PNUM(1:NF))	!Can N (as NPPOW) be divided by Q (as FQ)?
     1       .GE.         FQ(I).PPOW(1:NF))) THEN	!By comparing the supplies of prime factors.
              FRACTRAN = I			!Yes!
              NPPOW(FQ(I).PNUM(1:NF)) = NPPOW(FQ(I).PNUM(1:NF))	!Remove prime powers from N
     1            - FQ(I).PPOW(1:NF)				!Corresponding to Q.
              NF = FP(I).PNUM(0)				!Add powers to N
              NPPOW(FP(I).PNUM(1:NF)) = NPPOW(FP(I).PNUM(1:NF))	!Corresponding to P.
     1            + FP(I).PPOW(1:NF)				!Thus, N = N/Q*P.
             RETURN			!That's all it takes! No multiplies nor divides!
            END IF		!So much for that fraction.
          END DO		!This relies on ALL(zero tests) yielding true, as when Q = 1.
          FRACTRAN = 0		!No hit.
        END FUNCTION FRACTRAN	!No massive multi-precision arithmetic!

        SUBROUTINE SHOWN(S,F)	!Service routine to show the state after a step is calculated.
Could imaging a function I6FMT(23) that returns "    23" and "      " for non-positive numbers.
Can't do it, as if this were invoked via a WRITE statement, re-entrant use of WRITE usually fails.
         INTEGER S,F	!Step number, Fraction number.
         INTEGER I	!A stepper.
         CHARACTER*(9+4+1 + NL*6) ALINE	!A scratchpad matching FORMAT 103.
          WRITE (ALINE,103) S,F,NPPOW(PLIVE(1:NL))	!Show it!
  103     FORMAT (I9,I4,":",<NL>I6)	!As a sequence of powers of primes.
          IF (F.LE.0) ALINE(10:13) = ""	!Scrub when no fraction is fingered.
          DO I = 1,NL		!Step along the live primes.
            IF (NPPOW(PLIVE(I)).GT.0) CYCLE	!Ignoring the empowered ones.
            ALINE(15 + (I - 1)*6:14 + I*6) = ""	!Blank out zero powers.
          END DO		!On to the next.
          WRITE (MSG,"(A)") ALINE	!Reveal at last.
        END SUBROUTINE SHOWN	!A struggle.
      END MODULE CONWAYSIDEA	!Simple...

      PROGRAM POKE
      USE CONWAYSIDEA	!But, where does he get his ideas from?
      INTEGER P(ENUFF),Q(ENUFF)	!Holds the fractions as P(i)/Q(i).
      INTEGER N		!The working number.
      INTEGER LF	!Last fraction given.
      INTEGER LP	!Last prime needed.
      INTEGER MS	!Maximum number of steps.
      INTEGER I,IT	!Assistants.
      LOGICAL*1 PUSED(ENUFF)	!Track the usage of prime numbers,

      MSG = 6		!Standard output.
      WRITE (6,1)	!Announce.
    1 FORMAT ("Interpreter for J. H. Conway's FRACTRAN language.")

Chew into an example programme.
   10 OPEN (10,FILE = "Fractran.txt",STATUS="OLD",ACTION="READ")	!Rather than compiled-in stuff.
      READ (10,*) LF		!I need to know this without having to scan the input.
      WRITE (MSG,11) LF		!Reveal in case of trouble.
   11 FORMAT (I0," fractions, as follow:")	!Should the input evoke problems.
      READ (10,*)    (P(I),Q(I),I = 1,LF)	!Ask for the specified number of P,Q pairs.
      WRITE (MSG,12) (P(I),Q(I),I = 1,LF)	!Show what turned up.
   12 FORMAT (24(I0,"/",I0:", "))	!As P(i)/Q(i) pairs. The colon means that there will be no trailing comma.
      READ (10,*) N,MS			!The start value, and the step limit.
      CLOSE (10)			!Finished with input.
      WRITE (MSG,13) N,MS		!Hopefully, all went well.
   13 FORMAT ("Start with N = ",I0,", step limit ",I0)
      IF (.NOT.GRASPPRIMEBAG(66)) STOP "Gan't grab my file of primes!"	!Attempt in hope.

Convert the starting number to a more convenient form, an array of powers of successive prime numbers.
   20 FP(1) = FACTOR(N)		!Borrow one of the factor list variables.
      NPPOW = 0			!Clear all prime factor counts.
      DO I = 1,FP(1).PNUM(0)	!Now find what they are.
        NPPOW(FP(1).PNUM(I)) = FP(1).PPOW(I)	!Convert from a variable-length list
      END DO			!To a fixed-length random-access array.
      PUSED = NPPOW.GT.0	!Note which primes have been used.
      LP = FP(1).PNUM(FP(1).PNUM(0))	!Recall the last prime required. More later.
Convert the supplied P(i)/Q(i) fractions to lists of prime number factors and powers in FP(i) and FQ(i).
      DO I = 1,LF	!Step through the fractions.
        IT = GCD(P(I),Q(I))	!Suspicion.
        IF (IT.GT.1) THEN	!Justified?
          WRITE (MSG,21) I,P(I),Q(I),IT	!Alas. Complain. The rule is N*(P/Q) being integer.
   21     FORMAT ("Fraction ",I3,", ",I0,"/",I0,!N*6/3 is integer always because this is N*2/1, but 3 may not divide N.
     1     " has common factor ",I0,"!")	!By removing IT,
          P(I) = P(I)/IT			!The test need merely check if N is divisible by Q.
          Q(I) = Q(I)/IT			!And, as N is factorised in NPPOW
        END IF					!And Q in FQ, subtractions of powers only is needed.
        FP(I) = FACTOR(P(I))		!Righto, form the factor list for P.
        PUSED(FP(I).PNUM(1:FP(I).PNUM(0))) = .TRUE.	!Mark which primes it fingers.
        LP = MAX(LP,FP(I).PNUM(FP(I).PNUM(0)))		!One has no prime factors: PNUM(0) = 0.
        FQ(I) = FACTOR(Q(I))		!And likewise for Q.
        PUSED(FQ(I).PNUM(1:FQ(I).PNUM(0))) = .TRUE.	!Some primes may be omitted.
        LP = MAX(LP,FQ(I).PNUM(FQ(I).PNUM(0)))		!If no prime factors, PNUM(0) fingers element zero, which is zero.
      END DO		!All this messing about saves on multiplication and division.
Check which primes are in use, preparing an index of live primes..
      NL = 0		!No live primes.
      DO I = 1,LP	!Check up to the last prime.
        IF (PUSED(I)) THEN	!This one used?
          NL = NL + 1		!Yes. Another.
          PLIVE(NL) = I		!Fingered.
        END IF		!So much for that prime.
      END DO		!On to the next.
      WRITE (MSG,22) NL,LP,PRIME(LP)	!Remark on usage.
   22 FORMAT ("Require ",I0," primes only, up to Prime(",I0,") = ",I0)	!Presume always more than one prime.
      IF (LP.GT.LASTP) STOP "But, that's too many for array NPPOW!"

Cast forth a heading.
  100 WRITE (MSG,101) (PRIME(PLIVE(I)), I = 1,NL)	!Splat a heading.
  101 FORMAT (/,14X,"N as powers of prime factors",/,	!The prime heading,
     1 5X,"Step  F#:",<LP>I6)		!With primes beneath.
      CALL SHOWN(0,0)	!Initial state of N as NPPOW. Step zero, no fraction.

Commence!
      DO I = 1,MS	!Here we go!
        IT = FRACTRAN(LF)	!Do it!
        CALL SHOWN(I,IT)	!Show it!
        IF (IT.LE.0) EXIT	!Quit it?
      END DO		!The next step.
Complete!
      END	!Whee!
