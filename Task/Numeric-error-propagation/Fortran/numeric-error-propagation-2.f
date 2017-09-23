      MODULE ERRORFLOW	!Calculate with an error estimate tagging along.
       INTEGER VSP,VMAX		!Do so with an arithmetic stack.
       PARAMETER (VMAX = 28)	!Surely sufficient.
       REAL STACKV(VMAX)	!Holds the values.
       REAL STACKE(VMAX)	!And the corresponding error estimate.
       INTEGER VOUT		!Output file.
       LOGICAL VTRACE		!Perhaps progress is to be followed in detail.
       DATA VSP,VOUT,VTRACE/0,0,.FALSE./	!Start with nothing.
       CHARACTER*1 PM			!I'm stuck with code page 437 instead of 850.
       PARAMETER (PM = CHAR(241))	!Thus ± does not yield this glyph on a "console" screen. CHAR(241) does.
       CONTAINS		!The servants.
        SUBROUTINE VINIT(OUT)	!Get ready.
         INTEGER OUT		!Unit number for output.
          VSP = 0		!My stack is empty.
          VOUT = OUT		!Save this rather than have extra parameters.
          VTRACE = VOUT .GT. 0	!By implication.
        END SUBROUTINE VINIT	!Ready.
        SUBROUTINE VSHOW(WOT)	!Show the topmost element.
         CHARACTER*(*) WOT	!The caller identifies itself.
          IF (VSP.LE.0) THEN	!Just in case
            WRITE (VOUT,1) "Empty",VSP	!My stack may be empty.
           ELSE			!But normally, it is not.
            IF (STACKV(VSP).EQ.0) THEN	!But it might have a zero value!
              WRITE (VOUT,1) WOT,VSP,STACKV(VSP),PM,STACKE(VSP)		!Alas. No percentage, then.
    1         FORMAT (A8,": Vstack(",I2,") =",F8.1,A1,F6.2,F9.1,"%")	!Suits the example.
             ELSE		!Avoiding a divide-by-zero is polite.
              WRITE (VOUT,1) WOT,VSP,STACKV(VSP),PM,STACKE(VSP),	!Possibly, a surprise, still.
     1         STACKE(VSP)/STACKV(VSP)*100	!The relative error may well be interesting.
            END IF		!The pearls have been cast.
          END IF		!So much for protection.
        END SUBROUTINE VSHOW	!Could reveal all the stack...

        SUBROUTINE VLOAD(V,E)	!Load the stack.
         REAL V,E		!The value and its error.
          IF (VSP.GE.VMAX) STOP "VLOAD: overflow!"	!Oh dear.
          VSP = VSP + 1		!Up one.
          STACKV(VSP) = V	!Place the value.
          STACKE(VSP) = E	!And the error.
          IF (VTRACE) CALL VSHOW("vLoad")
        END SUBROUTINE VLOAD	!That was easy!

        SUBROUTINE VADD		!Add the top two elements.
          IF (VSP.LE.1) STOP "VADD: underflow!"	!Maybe not.
          STACKV(VSP - 1) = STACKV(VSP - 1) + STACKV(VSP)	!Do the deed.
          STACKE(VSP - 1) = SQRT(STACKE(VSP - 1)**2 + STACKE(VSP)**2)	!The errors follow.
          VSP = VSP - 1			!Two values have become one.
          IF (VTRACE) CALL VSHOW("vAdd")!The result.
        END SUBROUTINE VADD	!The variance of the sum is the sum of the variances.

        SUBROUTINE VSUB		!Subtract the topmost element from the one below.
          IF (VSP.LE.1) STOP "VSUB: underflow!"	!Perhaps not.
          STACKV(VSP - 1) = STACKV(VSP - 1) - STACKV(VSP)	!The topmost was the second loaded.
          STACKE(VSP - 1) = SQRT(STACKE(VSP - 1)**2 + STACKE(VSP)**2)	!Add the variances also.
          VSP = VSP - 1			!Two values have become one.
          IF (VTRACE) CALL VSHOW("vSub")!The result.
        END SUBROUTINE VSUB	!Could alternatively play with the signs and add...

        SUBROUTINE VMUL		!Multiply the top two elements.
         REAL R1,R2		!Use relative errors in place of plain SD.
          IF (VSP.LE.1) STOP "VMUL: underflow!"	!Perhaps not.
          R1 = STACKE(VSP - 1)/STACKV(VSP - 1)	!The relative errors for multiply
          R2 = STACKE(VSP)    /STACKV(VSP)	!Are treated as are variances in addition.
          STACKV(VSP - 1) = STACKV(VSP - 1)*STACKV(VSP)	!Perform the multiply.
          VSP = VSP - 1					!Unstack, but not quite finished.
          STACKE(VSP) = SQRT((R1**2 + R2**2)*STACKV(VSP)**2)	![SD/xy]² =  [SD/x]² + [SD/y]²
          IF (VTRACE) CALL VSHOW("vMul")			!Thus SD² = [[SD/x]² + [SD/y]²]xy²
        END SUBROUTINE VMUL	!The square means that the error's sign is not altered.

        SUBROUTINE VDIV		!Divide the penultimate element by the top elements.
         REAL R1,R2		!Use relative errors in place of plain SD.
          IF (VSP.LE.1) STOP "VDIV: underflow!"	!Perhaps not.
          R1 = STACKE(VSP - 1)/STACKV(VSP - 1)	!The relative errors for divide
          R2 = STACKE(VSP)    /STACKV(VSP)	!Are treated as are variances in subtraction.
          STACKV(VSP - 1) = STACKV(VSP - 1)/STACKV(VSP)	!Perform the divide.
          VSP = VSP - 1					!X/Y is Load X, Load Y, Divide; Y is topmost.
          STACKE(VSP) = SQRT((R1**2 + R2**2)*STACKV(VSP)**2)	![SD/(x/y)]² =  [SD/x]² + [SD/y]²
          IF (VTRACE) CALL VSHOW("vDiv")			!Thus SD² = [[SD/x]² + [SD/y]²](x/y)²
        END SUBROUTINE VDIV	!Worry over y ± SD spanning zero...

        SUBROUTINE VSQRT	!Now for some fun with the topmost element.
          IF (VSP.LE.0) STOP "VSQRT: underflow!"	!Maybe not.
          STACKV(VSP) = SQRT(STACKV(VSP))		!Negative? Let the system complain.
          STACKE(VSP) = 0.5/STACKV(VSP)*STACKE(VSP)	!F(x ± s) = F(x) ± F'(x).s
          IF (VTRACE) CALL VSHOW("vSqrt")		!Here, F' can't be negative.
        END SUBROUTINE VSQRT	!No change to the pointer.
        SUBROUTINE VSQUARE	!Another raise-to-a-power.
          STACKE(VSP) = 2*ABS(STACKV(VSP))*STACKE(VSP)	!The error's sign is not to be messed with.
          STACKV(VSP) = STACKV(VSP)**2		!This will never be negative.
          IF (VTRACE) CALL VSHOW("vSquare")	!Keep away from zero though.
        END SUBROUTINE VSQUARE	!Same formula as VSQRT, just a different power.
        SUBROUTINE VPOW(P)	!Now for the more general.
         INTEGER P		!Though only integer powers for this routine, so no EXP(P*LN(x)).
          IF (VSP.LE.0) STOP "VPOW: underflow!"	!Perhaps not.
          IF (P.EQ.0)   STOP "VPOW: zero power!"	!No sense in this power!
          STACKE(VSP) = P*ABS(STACKV(VSP))**(P - 1)*STACKE(VSP)	!Negative values a worry.
          STACKV(VSP) = ABS(STACKV(VSP))**P			!I only want the magnitude.
          IF (VTRACE) CALL VSHOW("vPower")	!So, what happened?
        END SUBROUTINE VPOW	!Powers with fractional parts are troublesome.
      END MODULE ERRORFLOW	!That will do for the test problem.

      PROGRAM CALCULATE	!A distance, with error propagation.
      USE ERRORFLOW	!For the details.
      REAL X1, Y1, X2, Y2	!The co-ordinates.
      REAL X1E,Y1E,X2E,Y2E	!Their standard deviation.
      DATA X1, Y1 ,X2, Y2 /100., 50., 200.,100./	!Specified
      DATA X1E,Y1E,X2E,Y2E/  1.1, 1.2,  2.2, 2.3/	!Values.

      WRITE (6,1) X1,PM,X1E,Y1,PM,Y1E,	!Reveal the points
     1            X2,PM,X2E,Y2,PM,Y2E	!Though one could have used an array...
    1 FORMAT ("Euclidean distance between two points:"/	!A heading.
     1 ("(",F5.1,A1,F3.1,",",F5.1,A1,F3.1,")"))		!Thus, One point per line.

Calculate SQRT[(X2 - X1)**2 + (Y2 - Y1)**2]
      CALL VINIT(6)		!Start my arithmetic.
      CALL VLOAD(X2,X2E)
      CALL VLOAD(X1,X1E)
      CALL VSUB			!(X2 - X1)
      CALL VSQUARE		!(X2 - X1)**2
      CALL VLOAD(Y2,Y2E)
      CALL VLOAD(Y1,Y1E)
      CALL VSUB			!Y2 - Y1)
      CALL VSQUARE		!Y2 - Y1)**2
      CALL VADD			!(X2 - X1)**2 + (Y2 - Y1)**2
      CALL VSQRT		!SQRT((X2 - X1)**2 + (Y2 - Y1)**2)
      WRITE (6,2) STACKV(1),PM,STACKE(1)	!Ahh, the relief.
    2 FORMAT ("Distance",F6.1,A1,F4.2)	!Sizes to fit the example.
      END	!Enough.
