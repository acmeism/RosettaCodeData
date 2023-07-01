      SUBROUTINE HQ9(CODE)	!Implement the rather odd HQ9+ instruction set.
       CHARACTER*(*) CODE	!One operation code per character.
       INTEGER I,B	!Steppers.
       INTEGER A	!An accumulator.
        A = 0		!Initialised.
        DO I = 1,LEN(CODE)	!Step through the code.
          SELECT CASE(CODE(I:I))!Inspect the operation code.
           CASE(" ")		!Might as well do nothing.
           CASE("+")		!Increment the accumulator.
            A = A + 1		!Thus. Though, nothing refers to it...
           CASE("h","H")	!Might as well allow upper or lower case.
            WRITE (6,*) "Hello, world!"	!Hi there!
           CASE("q","Q")	!Show the (rather questionable) code.
            WRITE (6,*) CODE	!Thus.
           CASE("9")		!Recite "99 bottles of beer"...
            DO B = 99,2,-1	!Grammar is to be upheld, so the singular case is special.
              WRITE (6,1) B,"bottles"," on the wall,",B,"bottles","."	!Two lots: number, text, text.
    1         FORMAT (I2,1X,A," of beer",A)	!Exhausted by the first triplet, so a new line for the second.
              WRITE (6,2)			!Now for the reduction.
    2         FORMAT ("Take one down, pass it around,")	!Announce.
              IF (B.GT.2) WRITE (6,1) B - 1,"bottles"," on the wall."	!But, not for the singular state.
            END DO		!Recite the next stanza.
            WRITE (6,1) 1,"bottle"," on the wall,",1,"bottle","."	!The singular case. No longer "bottles".
            WRITE (6,2)						!There's nothing so lonesome, morbid or drear,
            WRITE (6,*) "No bottles of beer on the wall."	!Than to stand at the bar of a pub with no beer.
            WRITE (6,*) "Go to the store, buy some more."	!Take action.
           CASE DEFAULT		!Denounce any unknown operation codes.
            WRITE (6,*) "Unrecognised code:",CODE(I:I)	!This is why a space is treated separately.
          END SELECT		!So much for that operation code.
        END DO			!On to the next.
      END SUBROUTINE HQ9	!That was odd.

      PROGRAM POKE
      CALL HQ9("hq9")
      END
