Catch some annoying cases, to protect the direct tests for divisibility by two and three...
          IF (N.LAST.LE.2) THEN	!A smallish number? I want to compare to four, but BIGBASE might be two.
            NR = BIGVALUE(N) 		!Surely so.
            IF (NR.LE.4) THEN		!Some special values are known.
              BIGMRPRIME = NR.GE.2 .AND. NR.LE.3	!Like, the neighbours.
              RETURN		!Thus allow 2 to be reported as prime.
            END IF		!Yet, test for 2 as a possible factor for larger numbers.
          END IF		!Without struggling over SQRT and suchlike.
          BIGMRPRIME = .FALSE.	!Most numbers are not primes.
          IF (BIGMOD2(N).EQ.0) RETURN	!A single expression using .OR. risks always evaluating BOTH parts, damnit,
          IF (BIGMODN(N,3).EQ.0) RETURN	!Even for even numbers. Possibly doing so "in parallel" is no consolation.
