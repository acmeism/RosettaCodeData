      INTEGER FUNCTION FRACTRAN(N,P,Q,M)	!Notion devised by J. H. Conway.
Careful: the rule is N*P/Q being integer. N*6/3 is integer always because this is N*2/1, but 3 may not divide N.
Could check GCD(P,Q), dividing out the common denominator so MOD(N,Q) works.
       INTEGER*8 N	!The work variable. Modified!
       INTEGER M	!The number of fractions supplied.
       INTEGER P(M),Q(M)!The terms of the fractions.
       INTEGER I	!A stepper.
        DO I = 1,M	!Search the supplied fractions, P(i)/Q(i).
          IF (MOD(N,Q(I)).EQ.0) THEN	!Does the denominator divide N?
            N = N/Q(I)*P(I)	!Yes, compute N*P/Q but trying to dodge overflow.
            FRACTRAN = I	!Report the hit.
           RETURN		!Done!
          END IF	!Otherwise,
        END DO		!Try the next fraction in the order supplied.
        FRACTRAN = 0	!No hit.
      END FUNCTION FRACTRAN	!That's it! Even so, "Turing complete"...

      PROGRAM POKE
      INTEGER FRACTRAN		!Not the default type of function.
      INTEGER P(66),Q(66)	!Holds the fractions as P(i)/Q(i).
      INTEGER*8 N		!The working number.
      INTEGER I,IT,L,M		!Assistants.

      WRITE (6,1)	!Announce.
    1 FORMAT ("Interpreter for J.H. Conway's FRACTRAN language.")

Chew into an example programme.
      OPEN (10,FILE = "Fractran.txt",STATUS="OLD",ACTION="READ")	!Rather than compiled-in stuff.
      READ (10,*) L	!I need to know this without having to scan the input.
      WRITE (6,2) L	!Reveal in case of trouble.
    2 FORMAT (I0," fractions, as follow:")	!Should the input evoke problems.
      READ (10,*) (P(I),Q(I),I = 1,L)	!Ask for the specified number of P,Q pairs.
      WRITE (6,3) (P(I),Q(I),I = 1,L)	!Show what turned up.
    3 FORMAT (24(I0,"/",I0:", "))	!As P(i)/Q(i) pairs. The colon means that there will be no trailing comma.
      READ (10,*) N,M			!The start value, and the step limit.
      CLOSE (10)			!Finished with input.
      WRITE (6,4) N,M			!Hopefully, all went well.
    4 FORMAT ("Start with N = ",I0,", step limit ",I0)

Commence.
      WRITE (6,10) 0,N		!Splat a heading.
   10 FORMAT (/,"  Step  #F: N",/,I6,4X,": ",I0)	!Matched FORMAT 11.
      DO I = 1,M		!Here we go!
        IT = FRACTRAN(N,P,Q,L)		!Do it!
        WRITE (6,11) I,IT,N		!Show it!
   11   FORMAT (I6,I4,": ",I0)		!N last, as it may be big.
        IF (IT.LE.0) EXIT		!No hit, so quit.
      END DO			!The next step.
      END	!Whee!
