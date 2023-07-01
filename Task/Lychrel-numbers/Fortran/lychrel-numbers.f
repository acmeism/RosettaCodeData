      SUBROUTINE CROAK(GASP)	!A dying message.
       CHARACTER*(*) GASP	!The message.
        WRITE (6,*) "Oh dear! ",GASP	!The gasp.
        STOP "Alas."		!The death.
      END			!Goodbye, cruel world.

      MODULE LYCHREL SEARCH	!Assistants for the pursuit of Lychrel numbers.
       INTEGER LOTSADIGITS,BASE	!Parameters.
       PARAMETER (LOTSADIGITS = 1000, BASE = 10)	!This should do.
       TYPE BIGINT	!Can't use an element zero as the count, as lots of digits are needed.
        INTEGER LDIGIT	!Count in use.
        INTEGER*1 DIGIT(LOTSADIGITS)	!Stored in increasing powers of BASE.
       END TYPE BIGINT		!No fractional parts.
       INTEGER MSTASH		!Now for my stash.
       PARAMETER (MSTASH = 66666)	!This should be enough.
       TYPE(BIGINT) STASH(MSTASH)	!The work area.
       INTEGER AVAILS(0:MSTASH)		!A list of available STASH entries.
       INTEGER PLIST(0:MSTASH)	!These strings of fingers
       INTEGER LLIST(0:MSTASH)	!Each starting with a count
       INTEGER LYCHREL(0:MSTASH)!Finger BIGINTs in the STASH
       INTEGER L0P(0:MSTASH)	!Without the body of the BIGINT being copied.
       INTEGER LONGESTNUMBER	!Keep track out of curiosity.
       DATA LONGESTNUMBER/0/	!No digits so far.
       CONTAINS		!A miscellany.
Commence with some STASH service. If problems were to arise, better error messages would be in order.
        SUBROUTINE PREPARESTASH	!Since fancy usage is involved, fancy initialisation is needed.
         INTEGER I	!A stepper.
          AVAILS(0) = MSTASH	!All are available.
          FORALL (I = 1:MSTASH) AVAILS(I) = MSTASH + 1 - I	!Will be used stack style.
          STASH.LDIGIT = -666				!This will cause trouble!
        END SUBROUTINE PREPARESTASH	!Simple enough.
        SUBROUTINE GRABSTASH(X)	!Finger an available STASH.
         INTEGER X		!The finger.
         INTEGER L		!The last.
          L = AVAILS(0)		!Pick on the last in the list.
          IF (L .LE. 0) CALL CROAK("Run out of stashes!")	!Hopefully not.
          X = AVAILS(L)		!Select some element or other.
          AVAILS(L) = 0		!Might as well unfinger.
          AVAILS(0) = L - 1	!As well as drop off the list.
        END SUBROUTINE GRABSTASH!Can't be bothered making this a function. Sudden death instead.
        SUBROUTINE FREESTASH(X)	!Unhand a STASH.
         INTEGER X		!The finger.
          IF (X.EQ.0) RETURN	!A non-finger.
          IF (X.LT.0) CALL CROAK("Unhanding a non-stash!")	!Paranoia.
          IF (X.GT.MSTASH) CALL CROAK("Not a stash!")		!I don't expect any of these.
          IF (AVAILS(0).GE.MSTASH) CALL CROAK("Over subscribed!")	!But on principle...
          AVAILS(0) = AVAILS(0) + 1	!So, append to the list of available entries.
          AVAILS(AVAILS(0)) = X		!Thus.
          X = 0				!The finger is amputated.
        END SUBROUTINE FREESTASH	!Last out, first in. Etc.

        SUBROUTINE BIGWRITE(T,N)!Reveal an annotated bignumber.
         CHARACTER*(*) T	!The text of its name.
         TYPE(BIGINT) N		!The value of its name.
          WRITE (6,1) T,N.LDIGIT,N.DIGIT(N.LDIGIT:1:-1)	!Roll!
    1     FORMAT (A,"(1:",I0,") = ",(300I1))	!This should do.
        END SUBROUTINE BIGWRITE	!Perhaps bigger than Integer*8.

        SUBROUTINE SHOWLIST(BLAH,LIST)	!One can become confused.
         INTEGER LIST(0:MSTASH)	!Explicit bounds prevents confusion.
         CHARACTER*(*) BLAH	!An identifying message.
         CHARACTER*4 ZOT	!Scratchpad.
         INTEGER I,IT		!Stepper.
c         REAL*8 V,P		!For logarithmic output.
c         INTEGER J		!Another stepper needed.
          WRITE (6,1) BLAH,LIST(0)		!A heading.
    1     FORMAT ("The count for ",A," is ",I0)	!Ah, layout.
          DO I = 1,LIST(0)		!Work through the list.
            WRITE(ZOT,"('#',I3)") I	!Prepare an annotation.
            IT = LIST(I)		!Finger the stash.
            CALL BIGWRITE(ZOT,STASH(IT))	!Show.
c            V = 0		!Convert the BIGINT to a floating-point number.
c            P = 1		!Tracking the powers of BASE, presumed ten.
c         PP:DO J = STASH(IT).LDIGIT,1,-1	!Start with the highest power.
c              V = V + STASH(IT).DIGIT(J)/P	!Deem it a units digit.
c              P = P*10				!The next digit will have a lesser power.
c              IF (P.GT.1000000) EXIT PP		!This will do.
c            END DO PP				!On to the next digit.
c            V = STASH(IT).LDIGIT - 1 + LOG10(V)	!Convert. LOG10(196) = 2.29225607135648
c            WRITE (6,*) I,V			!Reveal.
          END DO			!On to the next.
        END SUBROUTINE SHOWLIST	!Adrift in indirection.

        SUBROUTINE BIGLOAD(A,NUM)	!Shatters a proper number into its digits.
Can't overflow, because the biggest normal integer has far fewer than LOTSADIGITS digits.
         TYPE(BIGINT) A		!The bignumber.
         INTEGER NUM		!The normal integer to put in it.
         INTEGER L,N		!Assistants.
          N = NUM		!A copy that I can damage.
          A.DIGIT = 0		!Scrub, against a future carry..
          L = 0			!No digits so far.
          DO WHILE(N .GT. 0)	!Some number remaining?
            L = L + 1			!Yes. Count another digit.
            A.DIGIT(L) = MOD(N,BASE)	!Place it.
            N = N/BASE			!Reduce the number.
          END DO		!And try again.
          A.LDIGIT = MAX(1,L)	!Zero will have one digit, a zero.
        END SUBROUTINE BIGLOAD	!A small service.

Continue with routines for doing the work.
        SUBROUTINE ADVANCE(A,B)	!Advance A, giving B.
C Experiment shows that for 196, log10(v) = 0·43328*step + 2·1616, or, each advance increases by a factor of ~2·7.
         TYPE(BIGINT) A,B	!To be twiddled.
         INTEGER D		!An assistant for carrying.
         INTEGER I		!A stepper.
          B.LDIGIT = A.LDIGIT		!Same size, so far.
          FORALL(I = 1:A.LDIGIT)	!Do these in any order, even in parallel!
     1     B.DIGIT(I) = A.DIGIT(I)			!Add each digit
     2                + A.DIGIT(A.LDIGIT - I + 1)	! to its other-end partner.
          B.DIGIT(B.LDIGIT + 1) = 0	!Perhaps another digit will be needed shortly.
          DO I = 1,B.LDIGIT		!Now slow down and taste the carry.
            D = B.DIGIT(I) - BASE	!Allowable digits are 0:BASE - 1.
            IF (D.GE.0) THEN		!So, has this digit overflowed?
              B.DIGIT(I) = D			!Yes. Only addition, so no div and mod stuff.
              B.DIGIT(I + 1) = B.DIGIT(I + 1) + 1	!Carry one up, corresponding to subtracting one BASE down.
            END IF			!So much for that digit.
          END DO		!On to the next digit, of higher power.
          IF (D.GE.0) THEN	!A carry from the highest digit?
            IF (B.LDIGIT .GE. LOTSADIGITS) CALL CROAK("Overflow!")	!Oh dear.
            B.LDIGIT = B.LDIGIT + 1	!NB! Always there is room left for ONE more digit.
            LONGESTNUMBER = MAX(B.LDIGIT,LONGESTNUMBER)	!Perhaps a surprise awaits.
          END IF		!Avoids overflow testing for every carry above.
        END SUBROUTINE ADVANCE	!That was fun!

        LOGICAL FUNCTION PALINDROME(N)	!Perhaps a surprise property?
Calls a one-digit number palindromic through the execution of vacuous logic.
         TYPE(BIGINT) N	!The big number to inspect.
          PALINDROME = ALL(N.DIGIT(1:N.LDIGIT/2)	!Compare each digit in the first half...
     1                 .EQ.N.DIGIT(N.LDIGIT:N.LDIGIT/2 + 1:-1))	!To its opposite digit in the second. Whee!
        END FUNCTION PALINDROME	!If an odd number of digits, ignores the middle digit.

        INTEGER FUNCTION ORDER(A,B)	!Does B follow A?
         TYPE(BIGINT) A,B	!The two numbers.
         INTEGER I		!A stepper.
          IF (A.LDIGIT - B.LDIGIT) 1,10,2	!First, compare the lengths.
    1     ORDER = +1		!B has more digits.
         RETURN			!So, A must be smaller: in order.
    2     ORDER = -1		!A has more digits.
         RETURN			!So B must be smaller: reverse order.
Compare the digits of the two numbers, known to be of equal length.
   10     DO 11 I = A.LDIGIT,1,-1	!The last digit has the highest power.
            IF (A.DIGIT(I) - B.DIGIT(I)) 1,11,2	!Compare the digits.
   11     CONTINUE		!If they match, continue with the next digit.
          ORDER = 0		!If all match, A = B.
        END FUNCTION ORDER	!Ah, three-way tests...

        SUBROUTINE COMBSORT(XNDX)	!Sort according to STASH(XNDX)) by reordering XNDX.
Crank up a Comb sort of array STASH as indexed by XNDX.
         INTEGER XNDX(0:),T	!The index to be rearranged.
         INTEGER I,H		!Tools. H ought not be a small integer.
         LOGICAL CURSE		!Annoyance.
          H = XNDX(0) - 1	!Last - First, and not +1.
          IF (H.LE.0) GO TO 999	!Ha ha.
    1     H = MAX(1,H*10/13)	!The special feature.
          IF (H.EQ.9 .OR. H.EQ.10) H = 11	!A twiddle.
          CURSE = .FALSE.		!So far, so good.
          DO I = XNDX(0) - H,1,-1	!If H = 1, this is a BubbleSort.
            IF (ORDER(STASH(XNDX(I)),STASH(XNDX(I + H))) .LT. 0) THEN	!One compare.
              T=XNDX(I); XNDX(I)=XNDX(I+H); XNDX(I+H)=T		!One swap.
              CURSE = .TRUE.				!One curse.
            END IF				!One test.
          END DO			!One loop.
          IF (CURSE .OR. H.GT.1) GO TO 1!Work remains?
  999    RETURN			!If not, we're done.
        END SUBROUTINE COMBSORT	!Good performance, and simple.

        SUBROUTINE INSERTIONSORT(XNDX)	!Adjust XNDX according to STASH(XNDX)
Crank up an Insertion sort of array STASH as indexed by XNDX.
         INTEGER XNDX(0:),IT	!The index to be prepared, and a safe place.
         INTEGER I,L		!Fingers.
          DO L = 2,XNDX(0)	!Step along the array.
            IF (ORDER(STASH(XNDX(L - 1)),STASH(XNDX(L))) .LT. 0) THEN	!Disorder?
              I = L		!Yes. Element L belongs earlier.
              IT = XNDX(L)	!Save it so that others can be shifted up one.
    1         XNDX(I) = XNDX(I - 1)	!Shift one.
              I = I - 1		!The next candidate back.
              IF (I.GT.1 .AND. ORDER(STASH(XNDX(I - 1)),	!Do I have to go further back?
     1                               STASH(IT)).LT.0) GO TO 1	!Yes.
              XNDX(I) = IT	!Done. Place it in the space created.
            END IF		!So much for that comparison.
          END DO		!On to the next.
        END SUBROUTINE INSERTIONSORT	!Swift only if the array is nearly in order.

        INTEGER FUNCTION FOUNDIN(XNDX,X)	!Search STASH(XNDX) for X.
Crank up a binary serach. This uses EXCLUSIVE bounds.
         INTEGER XNDX(0:)	!The list of elements.
         TYPE(BIGINT) X		!The value to be sought.
         INTEGER L,P,R		!Fingers for the binary search.
          L = 0			!Establish outer bounds.
          R = XNDX(0) + 1	!One before, and one after, the first and last.
    1     P = (R - L)/2		!Probe point offset. Beware integer overflow with (L + R)/2.
          IF (P.LE.0) THEN	!Is the search span exhausted?
            FOUNDIN = -L	!Alas. X should follow position L but doesn't.
           RETURN		!Nothing more to search.
          END IF		!Otherwise, STASH(XNDX(L + 1)) <= X <= STASH(XNDX(R - 1))
          P = L + P		!Convert from offset to probe point.
          IF (ORDER(X,STASH(XNDX(P)))) 2,4,3	!Compare X to the probe point's value.
    2     L = P			!STASH(XNDX(P)) < X: advance L to P.
          GO TO 1		!Try again.
    3     R = P			!X < STASH(XNDX(P)): retract R to P.
          GO TO 1		!Try again.
Caught it! X = STASH(XNDX(P)) - the result indexes XNDX, not STASH.
    4     FOUNDIN = P		!So, X is found, here! *Not* at P, but at XNDX(P).
        END FUNCTION FOUNDIN	!Hopefully, without array copy-in, copy-out.

        SUBROUTINE INSPECT(S1,S2,ENUFF)	!Follow the Lychrel protocol.
Careful! A march is stopped on encountering a palindrome, BUT, the starting value is not itself checked.
         INTEGER S1,S2		!Start and stop values.
         INTEGER ENUFF		!An infinite trail can't be followed.
         INTEGER STEP,SEED	!Counts the advances along the long march.
         INTEGER START		!The first value of a march has special treatment.
         INTEGER MARCH(0:ENUFF)	!The waypoints of a long march.
         INTEGER DEJAVU		!Some may prove to be junctions.
         INTEGER LP,NP,LL,NL	!Counters for various odd outcomes.
          NP = 0		!No palindromic stops.
          LP = 0		!Nor any that head for one.
          NL = 0		!No neverending sequences seen.
          LL = 0		!Nor any that head for one.
          WRITE (6,10) S1,S2,ENUFF	!Announce the plan.
   10     FORMAT ("Starting values ",I0," to ",I0,"; step limit ",I0)
C   For each try, steps (but not the START) are saved in MARCH, and those steps end up in one list or another.
C Thus, there is no removal of their entries from the working STASH. If a plaindrome is found, or a step's value is
c noticed in the PLIST or LYCHREL list, the last STEP is not saved (being in that list, as a different entry in STASH)
c and its redundant value in STASH is unhanded via CALL FREESTASH(MARCH(STEP)).
c But if instead the MARCH is to be added to the LYCHREL list, the last value is included.
c   Since tries are made in increasing order, and ADVANCE always produces a bigger number, there is no point
c in saving the START value in STASH, except, some START values turn out to be notable and being saved in L0P
c or LLIST, their entry in STASH must not be rugpulled, thus the START = 0 to note this and prevent FREESTASH.
      TRY:DO SEED = S1,S2	!Here we go.
            CALL GRABSTASH(START)		!Ask for a starting space.
            CALL BIGLOAD(STASH(START),SEED)	!The starting value.
c            CALL BIGWRITE("N0",STASH(START))	!Show it.
c            IF (FOUNDIN(LYCHREL,STASH(START)) .GT. 0) THEN!	Have we been here during a long march?
c              WRITE (6,*) SEED,"Falls in!"		!Yes!
c              CYCLE TRY				!Nothing will be learnt by continuing.
c            END IF				!Otherwise, we're not discouraged.
            STEP = 1				!Even the longest journey stars with its first step.
            MARCH(0) = STEP			!And I'm remembering every step.
            CALL GRABSTASH(MARCH(STEP))		!A place for my first footfall.
            CALL ADVANCE(STASH(START),STASH(MARCH(STEP)))	!Start the stomping.
Contemplate the current step.
  100       CONTINUE	!Can't label a blank line...
c            CALL BIGWRITE("N1",STASH(MARCH(STEP)))	!Progress may be of interest.
            DEJAVU = FOUNDIN(PLIST,STASH(MARCH(STEP)))	!A value known to later become a palindrome?
            IF (DEJAVU .GT. 0) THEN			!It being amongst those stashed for that cause.
c              WRITE (6,*) SEED,STEP,"Deja vu! List#",DEJAVU
              LP = LP + 1				!Count a late starter.
              CALL FREESTASH(MARCH(STEP))		!The last step is already known.
              CALL SLURP(PLIST)				!Add the MARCH to the palindrome starters.
              GO TO 110					!And we're finished with this try.
            END IF					!So much for prospective palindromes.
            IF (PALINDROME(STASH(MARCH(STEP)))) THEN	!Attained an actual palindrome?
c              WRITE (6,*) SEED,STEP,"Palindrome!"	!Yes!
              NP = NP + 1				!Count a proper palendrome.
              CALL FREESTASH(MARCH(STEP))		!The last step is a palindrome.
              CALL SLURP(PLIST)				!So remember only those non-palindromes before it.
              GO TO 110					!This is a pretext for ending.
            END IF					!Since one could advance past a palindrome, and then find another.
            DEJAVU = FOUNDIN(LYCHREL,STASH(MARCH(STEP)))	!A value known to later pass ENUFF?
            IF (DEJAVU .GT. 0) THEN			!If so, there is no need to follow that march again.
c              WRITE (6,*) SEED,STEP,"Latecomer! List#",DEJAVU	!So this starter has been preempted.
c              CALL BIGWRITE("Latecomer!",STASH(LYCHREL(DEJAVU)))	!Or, STASH(MARCH(STEP)), they being equal.
              LLIST(0) = LLIST(0) + 1			!Count another latecomer.
              LLIST(LLIST(0)) = START			!This was its starting value's finger.
              IF (PALINDROME(STASH(START))) THEN	!Perhaps its starting value was also already a palindrome?
                L0P(0) = L0P(0) + 1				!Yes! Count another such.
                L0P(L0P(0)) = START				!Using a finger, rather than copying a BIGINT.
              END IF					!A Lychrel number whose zeroth step is palindromic.
              START = 0					!This is not to be unfingered!
              LL = LL + 1				!Anyway, this path has joined a known long march.
              CALL FREESTASH(MARCH(STEP))		!This value is already fingered in a list.
              CALL SLURP(LYCHREL)			!So, all its steps do so also, including the last.
              GO TO 110					!Even though its later start might find a palindrome within ENUFF steps.
            END IF					!So much for discoveries at each step.
            IF (STEP.LT.ENUFF) THEN	!Are we there yet?
              STEP = STEP + 1			!It seems there is no reason to stop.
              MARCH(0) = STEP			!So, the long march extends.
              CALL GRABSTASH(MARCH(STEP))	!Another step.
              CALL ADVANCE(STASH(MARCH(STEP - 1)),STASH(MARCH(STEP)))	!Lurch forwards.
              GO TO 100				!And see what happens here.
            END IF			!The end of the loop.
Chase completed, having reached STEP = ENUFF with no decision.
            WRITE (6,*) SEED,"retains Lychrel potential."	!Since a palindrome has not been reached.
            IF (PALINDROME(STASH(START))) THEN	!Perhaps it started as a palindrome?
              L0P(0) = L0P(0) + 1			!It did!
              L0P(L0P(0)) = START			!So remember it.
              START = 0					!And don't unhand this entry, a finger to it being saved.
            END IF				!Enough shades of classification.
            NL = NL + 1			!Count another at the end of a long march.
            CALL SLURP(LYCHREL)		!And save the lot, including the final value.
  110       IF (START.GT.0) CALL FREESTASH(START)	!The starting value was not held as a part of the MARCH.
          END DO TRY		!Start another.
Cast forth a summary.
          WRITE (6,*)
          WRITE (6,11) NL,ENUFF,LL,LYCHREL(0)
   11     FORMAT (I8," starters attained step ",I0," and ",
     1     I0," joined a long march. "
     2     I0," waypoints stashed.")
c          CALL SHOWLIST("starters that joined a Long March",LLIST)
          CALL SHOWLIST("Long Marchers starting as palindromes",L0P)
          WRITE (6,12) NP,LP,PLIST(0)
   12     FORMAT (I8," starters ended as a palindrome, ",
     1     I0," joined a route leading to a palindrome. ",
     2     I0," waypoints stashed.")
         CONTAINS	!An assistant.
          SUBROUTINE SLURP(LIST)	!Adds the elements in MARCH to LIST.
C   Entries in LIST are such that STASH(LIST(~)) is ordered. Because I arrange this.
C   Entries MARCH are also in increasing order as they are successive values from ADVANCE.
C   Accordingly, if only a few entries are to be added, a binary search can be used to find the
C location for insertion, and then existing entries can be shifted up to make room for the new entry.
C This is the basic task of Insertionsort, however, this shift can be conducted without invoking ORDER
C to determine its bounds, as is done by Insertionsort, and ORDER takes a lot of time to decide.
C In other words, the binary search makes only a few calls to ORDER and then the moves follow, in one go,
C whereas the Insertionsort makes as many calls to ORDER as it makes moves, and does so stepwise.
C   When many entries are to be added, they could be appended to LIST and then COMBSORT invoked.
C This is infrequent as few numbers evoke a lengthy march, so that method is adequate.
C But since both lists are in order, a merge of the two lists would be more stylish, if encoded clunkily.
C   It turns out that the incoming set may finger a value that is already in LIST,
c so equal values may appear. With the binary search method, such incomers can simply be skipped,
c but with the merge it is a bit more messy. In the event, the new value is discarded and the
c old one retained.
C   For instance, 5 -> 10 -> 11 so fingers for 5 and 10 are added to PLIST.
C Later on, 10 -> 11 and a finger for 10 is to be added to PLIST, because the starting value is not checked.
C However, a later version refrains from adding the (unchecked) starting value, and then, no worries.
           INTEGER LIST(0:MSTASH)	!Some string of numbers.
           INTEGER MIST(0:MSTASH)	!LIST(0) is the upper bound, but risks stack overflow.
           INTEGER I,S,L		!A stepper.
Check for annoying nullities.
    1       IF (MARCH(0).LE.0) RETURN	!An empty march already!
            IF (MARCH(MARCH(0)).LE.0) THEN	!Otherwise, look at the last step.
              MARCH(0) = MARCH(0) - 1		!It was boring.
              GO TO 1				!So, go back one and look afresh.
            END IF			!Having snipped off trailing nullities, what remains means effort.
Can't escape some work.
            IF (MARCH(0) .LE. 6) THEN	!If we have a few only,
              DO I = 1,MARCH(0)		!Work through them one by one,
                S = MARCH(I)			!The finger for this step of the march.
                IF (S.LE.0) CYCLE		!A stump?
                L = FOUNDIN(LIST,STASH(S))	!Using a binary search to find the proper place.
                IF (L.GT.0) THEN		!If already present,
                  CALL FREESTASH(S)		!Its entry is no longer needed.
                  CYCLE				!So skip this.
                END IF				!But if not found, a place must be made.
                L = 1 - L			!Finger where the missing element should be.
                LIST(LIST(0) + 1:L + 1:-1) = LIST(LIST(0):L:-1)	!Shift followers up to make space.
                LIST(0) = LIST(0) + 1		!Count another.
                LIST(L) = S			!Place it.
              END DO			!On to the next.
             ELSE	!But if there are many to add, merge the two lists... Both are ordered.
              MIST(0:LIST(0)) = LIST(0:LIST(0))	!Copy the source list.
              LIST(0) = 0		!It is to be reformed by the merge.
              L = 1			!Start with the first in MIST.
              DO I = 1,MARCH(0)		!And work along the long MARCH.
                S = MARCH(I)		!So, a step from the long march.
                IF (S.LE.0) CYCLE	!And if not an empty step, we have one.
   11           LIST(0) = LIST(0) + 1		!Count in another for this list.
                IF (L.LE.MIST(0)) THEN		!Still have suppliers from what had been LIST?
                  IF (ORDER(STASH(MIST(L)),STASH(S))) 14,13,12	!Yes, Which is to be selected?
   12             LIST(LIST(0)) = MIST(L)	!STASH(MIST(L)) precedes STASH(S), so take it.
                  L = L + 1			!Advance to the next MIST entry.
                  GO TO 11			!And look again.
   13             CALL FREESTASH(S)		!Equal. Discard the new entry.
                  S = MIST(L)			!And pefer the established entry.
                  L = L + 1			!Advance past the MIST(L) entry.
                END IF			!Thus, MIST entries have been rolled until a MARCH entry was due.
   14           LIST(LIST(0)) = S	!Save the finger - which may have come from MIST...
              END DO			!On to the next MARCH.
              S = MIST(0) - L + 1	!The number of MIST entries still waiting.
              IF (S .GT. 0) THEN	!Are there any?
                LIST(LIST(0) + 1:LIST(0) + S) = MIST(L:MIST(0))	!Yes. Append them.
                LIST(0) = LIST(0) + S	!And count them in.
              END IF			!So much for the merge.
            END IF			!Otherwise, a COMBSORT would do.
          END SUBROUTINE SLURP	!Can't overflow, because each LIST has room for MSTASH entries.
        END SUBROUTINE INSPECT	!That was fun.
      END MODULE LYCHREL SEARCH	!Enough of that.

      PROGRAM TEST
      USE LYCHREL SEARCH
       CALL PREPARESTASH
Clear my lists.
       LYCHREL = 0	!No Lychrel candidates.
       LLIST = 0	!No latecomers to a Lychrel candidacy sequence.
       PLIST = 0	!No numbers leading to a palindrome.
       L0P = 0		!No Lychrel/latecomers starting as a palindrome.

       CALL INSPECT(1,10000,500)	!Whee!

       WRITE (6,*) "Longest digit string =",LONGESTNUMBER
       WRITE (6,*) "Unused STASH entries =",AVAILS(0)
      END
