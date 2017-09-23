Calculates "left factorials", in sequence, and shows some.
      INTEGER ENUFF,BASE	!Some parameters.
      PARAMETER (BASE = 10, ENUFF = 40000)	!This should do.
      INTEGER LF,F(ENUFF),LS,S(ENUFF)	!Big numbers in digits F(1:LF), S(1:LS)
      INTEGER N		!A stepper.
      INTEGER L		!Locates digits.
      INTEGER C		!A carry for arithmetic.
      INTEGER MSG	!I/O unit number.

      MSG = 6	!Standard output.
      LF = 1; F(1) = 1	!Set F = 1 = 0!
      LS = 1; S(1) = 0	!Set S = 0 = !0
      WRITE (MSG,1) 0,0	!Pre-emptive first result.
    1 FORMAT ("!",I0,T6,666I1)	!This will do for reasonable sizes.

   10 DO N = 1,10000	!Step away.
Commence the addition of F to S.
   20   C = 0		!Clear the carry.
        DO L = 1,MIN(LF,LS)	!First, both S and F have low-order digits.
          C = S(L) + F(L) + C		!So, a three-part addition.
          S(L) = MOD(C,BASE)		!Place the digit.
          C = C/BASE			!Carry to the next digit up.
        END DO			!Ends with L and C important.
Careful. L fingers the next digit up, and C is to carry in to that digit.
        IF (LF.GT.LS) THEN	!Has F more digits than S?
          DO L = L,LF		!Yes. Continue adding, with leading zero digits from S.
            C = F(L) + C		!Thus.
            LS = LS + 1			!Another digit for S.
            S(LS) = MOD(C,BASE)		!Place.
            C = C/BASE			!Carry to the next digit up.
          END DO		!Continue to the end of F.
        END IF			!Either way, F has been added in.
Continue carrying, with C for digit L.
        DO WHILE(C .GT. 0)	!Extend the carry into S.
          IF (L.LE.LS) THEN		!If F had fewer digits than S,
            C = C + S(L)		!S digits await.
           ELSE			!Otherwise,
            LS = LS + 1			!Extend S.
          END IF		!C is ready.
          S(L) = MOD(C,BASE)	!Place it.
          C = C/BASE		!The carry for the next digit up.
          L = L + 1		!Locate it.
        END DO			!Perhaps a multi-digit carry.
Contemplate what to do with the current S.
        IF (N.LE.10) THEN		!First selection: !N for 0 to 10.
          WRITE (MSG,1) N,S(LS:1:-1)		!Show the value. Digits from the high-order end down.
        ELSE IF (20.LE.N .AND. N.LE.110) THEN	!Second selection: for 20 to 110,
          IF (MOD(N,10).EQ.0) WRITE (MSG,1) N,S(LS:1:-1)	!Show only every tenth.
        ELSE					!Third selection
          IF (MOD(N,1000).EQ.0) WRITE (MSG,21) N,LS	!Show only the number of digits.
   21     FORMAT ("!",I0," has ",I0," digits.")		!Which is why BASE is only 10.
        END IF				!So much for the selection of output.
Calculate the next factorial, ready for the next one up.
        C = 0		!Start a multiply.
        DO L = 1,LF	!Step up the digits to produce N! in F.
          C = F(L)*N + C	!A digit.
          F(L) = MOD(C,BASE)	!Place.
          C = C/BASE		!Extract the carry.
        END DO		!On to the next digit.
        DO WHILE(C .GT. 0)	!While any carry remains,
          LF = LF + 1			!Add another digit to F.
          IF (LF.GT.ENUFF) STOP "F overflow!"	!Perhaps not.
          F(LF) = MOD(C,BASE)		!The digit.
          C = C/BASE			!Carry to the next digit up.
        END DO			!If there is one, as when N > BASE.
      END DO		!On to the next result.
      END	!Ends with a new factorial that won't be used.
