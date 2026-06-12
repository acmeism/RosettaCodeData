      SUBROUTINE PLOTS(DX,DY,DEVICE)
       INTEGER DEVICE(10)
       COMMON LINPR
        WRITE (LINPR,*) "PlotS:",DX,DY,DEVICE
      END
      SUBROUTINE PLOT(X,Y,IHIC)
       COMMON LINPR
        WRITE (LINPR,*) "Plot:",X,Y,IHIC
      END
      SUBROUTINE FACTOR(F)
       COMMON LINPR
        WRITE (LINPR,*) "PlotFactor:",F
      END
      SUBROUTINE SYMBOL(X,Y,H,T,A,N)
       INTEGER T(1)
       COMMON LINPR
        WRITE (LINPR,*) "PlotSymbol:",X,Y,H,T,A,N
      END
      SUBROUTINE NUMBER(X,Y,H,V,A,N)
        COMMON LINPR
        WRITE (LINPR,*) "PlotNumber:",X,Y,H,V,A,N
      END
C==================The above suppresses attempts to access a long-lost plotting system
c      FUNCTION CPUTIM(I)
c        CALL INTVAL(-3,IWASTE)
c        CPUTIM = FLOAT(IWASTE)/1000
c        IF (I .EQ. 0) CALL STIME
c        RETURN
c      END
      LOGICAL FUNCTION PRANGE(X1,X2,Y1,Y2)
       LOGICAL ROTATE,DIVE
       INTEGER DEVICE(10),CARDS,BLANK
       COMMON /PLOTIT/ ROTATE,DIVE,DEVICE,BLOAT
       COMMON LINPR,CARDS
       DATA BLANK/'    '/
        PRANGE = DIVE
        IF (DIVE) RETURN
        IF (DEVICE(1).NE.BLANK) GO TO 10
        WRITE (LINPR,1)
    1   FORMAT (' Name your output device (TEK618,GDDM78,..)')
        READ (CARDS,2) DEVICE(1),DEVICE(2)
    2   FORMAT (2A4)
   10   DEVICE(3) = 0
        DEVICE(4) = 4*10
        DX = X2 - X1
        DY = Y2 - Y1
        IF (.NOT.ROTATE) CALL PLOTS(DX,DY,DEVICE)
        IF (     ROTATE) CALL PLOTS(DY,DX,DEVICE)
        PRANGE = DEVICE(3).EQ.0
        IF (PRANGE) GO TO 100
        WRITE (LINPR,11) (DEVICE(I),I = 1,4)
   11   FORMAT (' Muckup.',2A4,2I9)
       RETURN
  100   CALL PLOT(0.0,0.0,3)
        D = AMAX1(DX,DY)
        IF (     ROTATE) CALL FACTOR(BLOAT)
        IF (.NOT.ROTATE) CALL PLOT(-X1,-Y1,-3)
        IF (     ROTATE) CALL PLOT( Y2,-X1,-3)
       RETURN
      END
      SUBROUTINE PLOTXY(X,Y,I)
       LOGICAL ROTATE,DIVE
       COMMON /PLOTIT/ ROTATE,DIVE
C (x,y)*(0,1) = (-y,x), a 90-degree rotation.
        IF (DIVE) RETURN
        IF (.NOT.ROTATE) CALL PLOT( X,Y,I)
        IF (     ROTATE) CALL PLOT(-Y,X,I)
       RETURN
      END
      SUBROUTINE SYMBXY(X,Y,H,T,A,N)
       LOGICAL ROTATE,DIVE
       INTEGER T(1)
       COMMON /PLOTIT/ ROTATE,DIVE
        IF (DIVE) RETURN
        IF (.NOT.ROTATE) CALL SYMBOL(X,Y,H,T,A,N)
        IF (     ROTATE) CALL SYMBOL(-Y,X,H,T,A + 90,N)
       RETURN
      END
      SUBROUTINE NUMBXY(X,Y,H,V,A,N)
       LOGICAL ROTATE,DIVE
       COMMON /PLOTIT/ ROTATE,DIVE
        IF (DIVE) RETURN
        IF (.NOT.ROTATE) CALL NUMBER(X,Y,H,V,A,N)
        IF (     ROTATE) CALL NUMBER(-Y,X,H,V,A + 90,N)
       RETURN
      END
      SUBROUTINE DOBOX(X1,Y1,X2,Y2)
        CALL PLOTXY(X1,Y1,3)
        CALL PLOTXY(X2,Y1,2)
        CALL PLOTXY(X2,Y2,2)
        CALL PLOTXY(X1,Y2,2)
        CALL PLOTXY(X1,Y1,2)
       RETURN
      END
C============Above are routines for producing plots.
      SUBROUTINE SWAPI(I,J)
        IT = I
        I = J
        J = IT
       RETURN
      END
      SUBROUTINE NEWTON(X,Y,Z,AX,AY,AZ,M,N)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 X(N),Y(N),Z(N),AX(N),AY(N),AZ(N),M(N)
       REAL*8 MI,MJ
       COMMON /CONST/ G,CLOSE
        DO 1 I = 1,N
          AX(I) = 0.0
          AY(I) = 0.0
    1     AZ(I) = 0.0
        NL1 = N - 1
        DO 3 I = 1,NL1
          AXI = AX(I)
          AYI = AY(I)
          AZI = AZ(I)
          MI = M(I)
          XI = X(I)
          YI = Y(I)
          ZI = Z(I)
          J = I + 1
          DO 2 J = J,N
            MJ = M(J)
            DX = X(J) - XI
            DY = Y(J) - YI
            DZ = Z(J) - ZI
            D2 = DZ*DZ + DY*DY + DX*DX
            IF (D2 .LT. CLOSE) CLOSE = D2
            F = G/(D2*DSQRT(D2))
            AIJ = F*DX
            AXI = AXI + MJ*AIJ
            AX(J) = AX(J) - MI*AIJ
            AIJ = F*DY
            AYI = AYI + MJ*AIJ
            AY(J) = AY(J) - MI*AIJ
            AIJ = F*DZ
            AZI = AZI + MJ*AIJ
    2       AZ(J) = AZ(J) - MI*AIJ
          AX(I) = AXI
          AY(I) = AYI
    3     AZ(I) = AZI
       RETURN
      END
      SUBROUTINE NEWT(X,A,N)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 X(100,3),A(100,3),M(100)
       COMMON /CONST/ G,CLOSE,M
        CALL NEWTON(X(1,1),X(1,2),X(1,3),A(1,1),A(1,2),A(1,3),M,N)
       RETURN
      END
      SUBROUTINE PROBE(X,X2,V,A,N,DT)
C Looks ahead one time step.
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 X(100,3),V(100,3),A(100,3)
       REAL*8 X2(100,3)
        DO 1 I = 1,N
          DO 1 J = 1,3
    1       X2(I,J) = X(I,J) + (V(I,J) + 0.5*A(I,J)*DT)*DT
       RETURN
      END
      SUBROUTINE EULER(K,L,N,T,DT)
Computes the first order advance. Uses A at T only.
       IMPLICIT REAL*8 (A-H,O-Z)
       COMMON /PLACE/ X(100,3,14),V(100,3,14),A(100,3,14)
        CALL NEWT(X(1,1,K),A(1,1,K),N)
        DO 2 I = 1,N
          DO 2 J = 1,3
            VIJ = V(I,J,K)
            AIJDT = A(I,J,K)*DT
            V(I,J,L) = VIJ + AIJDT
    2       X(I,J,L) = X(I,J,K) + (VIJ + 0.5*AIJDT)*DT
        T = T + DT
       RETURN
      END
      SUBROUTINE LUNGE(K,L,N,T,DT)
Computes a second order advance (Huen's, or 2'nd order Euler).
C  Uses A(t) to probe ahead to X(t + dt) to find A(t + dt)
C  and then averages the two to advance one step.
       IMPLICIT REAL*8 (A-H,O-Z)
       COMMON /PLACE/ X(100,3,14),V(100,3,14),A(100,3,14)
        CALL NEWT (X(1,1,K),A(1,1,K),N)
        CALL PROBE(X(1,1,K),X(1,1,L),V(1,1,K),A(1,1,K),N,DT)
        CALL NEWT (X(1,1,L),A(1,1,L),N)
        DO 2 I = 1,N
          DO 2 J = 1,3
            VIJ = V(I,J,K)
            AIJDT = (A(I,J,K) + A(I,J,L))*0.5*DT
            V(I,J,L) = VIJ + AIJDT
    2       X(I,J,L) = X(I,J,K) + (VIJ + 0.5*AIJDT)*DT
        T = T + DT
       RETURN
      END
      SUBROUTINE RUNGE(K,L,N,T,DT)
Classic Runge-Kutta fourth order advance.
C   1) Use A(t)         to reach x2(t + dt/2) and compute a2(t + dt/2)
C   2) Use a2(t + dt/2) to reach x3(t + dt/2) and compute a3(t + dt/2)
C   3) Use a3(t + dt/2) to reach x4(t + dt)   and compute a4(t + dt/2)
C   4) Use a weighted average of a,a2,a3,a4 to make the actual advance.
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 A3(100,3),A4(100,3)
       COMMON /PLACE/ X(100,3,14),V(100,3,14),A(100,3,14)
        CALL NEWT (X(1,1,K),A(1,1,K),N)
        CALL PROBE(X(1,1,K),X(1,1,L),V(1,1,K),A(1,1,K),N,DT/2)
        CALL NEWT (X(1,1,L),A(1,1,L),N)
        CALL PROBE(X(1,1,K),X(1,1,L),V(1,1,K),A(1,1,L),N,DT/2)
        CALL NEWT (X(1,1,L),A3,N)
        CALL PROBE(X(1,1,K),X(1,1,L),V(1,1,K),A3,N,DT)
        CALL NEWT (X(1,1,L),A4,N)
        DO 2 I = 1,N
          DO 2 J = 1,3
            VIJ = V(I,J,K)
            AIJ = (A(I,J,K) + 2.*(A(I,J,L) + A3(I,J)) + A4(I,J))/6.
            A(I,J,L) = AIJ
            AIJDT = AIJ*DT
            V(I,J,L) = VIJ + AIJDT
    2       X(I,J,L) = X(I,J,K) + (VIJ + 0.5*AIJDT)*DT
        T = T + DT
       RETURN
      END
      SUBROUTINE SCLEAR
       COMMON /STORE/ N,INDEXS(14)
        N = 0
        DO 1 I = 1,14
    1     INDEXS(I) = 14 - I + 1
       RETURN
      END
      SUBROUTINE SGRAB(IT)
       COMMON /STORE/ N,INDEXS(14)
        IT = INDEXS(N)
        N = N - 1
       RETURN
      END
      SUBROUTINE SFREE(IT)
       COMMON /STORE/ N,INDEXS(14)
        IF (IT .LE. 0) RETURN
        N = N + 1
        INDEXS(N) = IT
        IT = 0
       RETURN
      END
      SUBROUTINE MILNE(N,T,T1,DT,EPS,NSTEP)
Chase along according to the Milne predictor-corrector scheme.
C  1) Predict: Fit a parabola to the last three a's. (k-2,k-1,k)
C      Integrate from (k-3) to (k+1) giving v(k+1)
C      Fit a parabola to the latest v's (k-1,k,k+1)
C      Integrate from (k-1) to (k+1) giving x(k+1)
C      Compute a(kp1) at x(k+1), i.e. a(t + dt).
C  2) Correct: Repeat the prediction step, using k-1,k,k+1.
C      There are details. By integrating from (k-3) to (k+1) we have a
C      symmetrical region of the parabola fitted to (k-1),(k),(k+1),
C      which means that P4 is exact for cubics.
C      Secondly, the correction step doesn't need to extrapolate
C      because we have an estimate for (k+1). (The whole point!)
C  3) Check:   The difference between the predicted and corrected a's.
C      Instead of iterating the corrector until (pred - corr) is small,
C      which involves repeated evaluations of the a's at the various
C      corrected x's, all of which are more or less at the same point,
C      the scheme here is to refine the sampling of the whole interval
C      x(k) to x(k+1) by halving the step size, thereby sampling the
C      behaviour at a more even spread of positions.
       IMPLICIT REAL*8 (A-H,O-Z)
       COMMON /STORE/ NAVAIL,INDEXS(14)
       COMMON /PLACE/ X(100,3,14),V(100,3,14),A(100,3,14)
       REAL*8 EXTRAP(100,3)
Compute assorted integrals.
       P4(Y1,Y2,Y3) = 2.*(Y1 + Y3) - Y2
       P3(Y1,Y2,Y3) = Y1 + Y3 + 4.*Y2
       P24(Y1,Y2,Y3) = 2.*Y3 - Y1 + 11.*Y2
        KMAX = 14
        BB = 0
        NSTEP = 0
C
Concoct a past history from which to extrapolate.
        DO 1 K = 1,3
          CALL RUNGE(K,K + 1,N,T,DT)
          CALL JOIN(K,K + 1,N)
    1     CONTINUE
        KP1 = 5
        K   = 4
        KL1 = 3
        KL2 = 2
        KL3 = 1
        KL4 = 0
        KL5 = 0
        KL6 = 0
        NAVAIL = 0
        DO 2 I = 6,KMAX
          NAVAIL = NAVAIL + 1
    2     INDEXS(NAVAIL) = KMAX - I + 6
C
Cook up an estimate of the A's at KP1, one time step ahead.
   10   H3 = DT/3
        H4 = DT*4/3
C       WRITE (6,666) NSTEP,T,DT,  NAVAIL,KL6,KL5,KL4,KL3,KL2,KL1,K,KP1
  666   FORMAT (I4,F7.2,F9.4,14X   ,I3,':',8I3)
        DO 11 I = 1,N
          DO 11 J = 1,3
            VT = V(I,J,KL3) + H4*P4(A(I,J,KL2),A(I,J,KL1),A(I,J,K))
            V(I,J,KP1) = VT
            X(I,J,KP1) = X(I,J,KL1) + H3*P3(V(I,J,KL1),V(I,J,K),VT)
   11       CONTINUE
C
Compute the A's at the extrapolated position, thus involving the DE.
        CALL NEWT(X(1,1,KP1),EXTRAP,N)
C
Correct the X's and V's now that the story at KP1 is known (sortof).
   20   DO 21 I = 1,N
          DO 21 J = 1,3
            VT = V(I,J,KL1) + H3*P3(A(I,J,KL1),A(I,J,K),EXTRAP(I,J))
            V(I,J,KP1) = VT
            X(I,J,KP1) = X(I,J,KL1) + H3*P3(V(I,J,KL1),V(I,J,K),VT)
   21       CONTINUE
C
Calculate new A's to ensure a coherent solution of the DE.
        CALL NEWT(X(1,1,KP1),A(1,1,KP1),N)
C
Compare the provisional and the accepted A's.
   30   B = 0
        DO 32 I = 1,N
          D = 0.
          DP = 0.
          DC = 0.
          DO 31 J = 1,3
            AP = EXTRAP(I,J)
            AC = A(I,J,KP1)
            D = D + (AP - AC)**2
            DP = DP + AP*AP
            DC = DC + AC*AC
   31       CONTINUE
          DPC = DP + DC
          IF (DPC .LE. 0.0) DPC = 1
          D = D/DPC
   32     IF (D .GT. B) B = D
        IF (B .GT. BB) BB = B
C       WRITE (6,667)            B,NAVAIL,KL6,KL5,KL4,KL3,KL2,KL1,K,KP1
  667   FORMAT (20X,         F14.11,I3,':',8I3)
        IF (B .LT. EPS) GO TO 50
C
Chop the step size in half. Interpolate IL1, IL3
   40   CALL SFREE(KL6)
        CALL SFREE(KL5)
        CALL SFREE(KL4)
        CALL SFREE(KL3)
        CALL SGRAB(IL3)
        CALL SGRAB(IL1)
        H24 = DT/24
        DO 41 I = 1,N
          DO 41 J = 1,3
            AK = A(I,J,K)
            AKL1 = A(I,J,KL1)
            AKL2 = A(I,J,KL2)
            VKL1 = V(I,J,KL1)
            VIL1 = VKL1 + H24*P24(AKL2,AKL1,AK)
            VIL3 = VKL1 - H24*P24(AK,AKL1,AKL2)
            V(I,J,IL3) = VIL3
            V(I,J,IL1) = VIL1
            VK = V(I,J,K)
            VKL2 = V(I,J,KL2)
            XKL1 = X(I,J,KL1)
            XIL1 = XKL1 + H24*P24(VKL2,VKL1,VK)
            XIL3 = XKL1 - H24*P24(VK,VKL1,VKL2)
            X(I,J,IL3) = XIL3
   41       X(I,J,IL1) = XIL1
        CALL NEWT(X(1,1,IL1),A(1,1,IL1),N)
        CALL NEWT(X(1,1,IL3),A(1,1,IL3),N)
        KL4 = KL2
        KL3 = IL3
        KL2 = KL1
        KL1 = IL1
        DT = DT/2
        GO TO 10
C
Complete the step by advancing all fingers.
   50   NSTEP = NSTEP + 1
        T = T + DT
        CALL SFREE(KL6)
        KL6 = KL5
        KL5 = KL4
        KL4 = KL3
        KL3 = KL2
        KL2 = KL1
        KL1 = K
        K   = KP1
        CALL SGRAB(KP1)
        CALL JOIN(KL1,K,N)
        IF (T .GE. T1) GO TO 100
C
Consider doubling the step size.
   60   IF (B .GE. EPS/36) GO TO 10
        IF (KL4*KL5*KL6 .LE. 0) GO TO 10
C       WRITE (6,668)              NAVAIL,KL6,KL5,KL4,KL3,KL2,KL1,K,KP1
  668   FORMAT (34X,                I3,':',8I3)
        CALL SFREE(KL1)
        CALL SFREE(KL3)
        CALL SFREE(KL5)
        KL1 = KL2
        KL2 = KL4
        KL3 = KL6
        KL4 = 0
        KL5 = 0
        KL6 = 0
        DT = DT*2
        GO TO 10
Completed.
  100   CALL PLOTXY(0.0,0.0,999)
        WRITE (6,*) "Bmax=",BB
        CALL PRINT(X(1,1,K),V(1,1,K),1,N)
       RETURN
      END
      SUBROUTINE JOIN(K,L,N)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL U,V
       COMMON /PLACE/ X(100,3,14)
       COMMON /SCOPE/ IU,IV,UMIN,VMIN,US,VS
        DO 1 I = 1,N
          U = (X(I,IU,K) - UMIN)*US
          V = (X(I,IV,K) - VMIN)*VS
          CALL PLOTXY(U,V,3)
          U = (X(I,IU,L) - UMIN)*US
          V = (X(I,IV,L) - VMIN)*VS
C         CALL PLOTXY(U,V,2)
          IT = MOD(I,14)
          CALL SYMBXY(U,V,0.05,IT,0.0,-2)
    1     CONTINUE
       RETURN
      END
      SUBROUTINE PRINT(X,V,IST,LST)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 X(100,3),V(100,3)
        IF (IST.GT.LST) RETURN
        DO 3 I = IST,LST
          RXYZ = 0.0
          VXYZ = 0.0
          DO 1 J = 1,3
            RXYZ = RXYZ + X(I,J)**2
   1        VXYZ = VXYZ + V(I,J)**2
            RXYZ = DSQRT(RXYZ)
            VXYZ = DSQRT(VXYZ)
          WRITE (6,2) I,(X(I,J),J = 1,3),RXYZ,(V(I,J),J = 1,3),VXYZ
   2      FORMAT (I3,2(4F8.5,3X))
   3      CONTINUE
       RETURN
      END
      FUNCTION PE(N,L)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 M(100)
       COMMON /CONST/ G,CLOSE,M
       COMMON /PLACE/ X(100,3,14)
        T = 0
        NL1 = 1
        DO 2 I = 1,NL1
          IP1 = I + 1
          DO 2 J = IP1,N
            R2 = 0.0
            DO 1 K = 1,3
    1         R2 = R2 + (X(I,K,L) - X(J,K,L))**2
    2      T = T - M(I)*M(J)/DSQRT(R2)
        PE = G*T
       RETURN
      END
      REAL FUNCTION KE(N,L)
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 M(100)
       COMMON /CONST/ G,CLOSE,M
       COMMON /PLACE/ X(100,3,14),V(100,3,14)
        T = 0
        DO 2 I = 1,N
          V2 = 0
          DO 1 J = 1,3
    1       V2 = V2 + V(I,J,L)**2
    2     T = T + M(I)*V2
        KE = T/2
       RETURN
      END
      SUBROUTINE COM(N,L,TM,W,P)
Centre of mass.....
       IMPLICIT REAL*8 (A-H,O-Z)
       REAL*8 M(100),W(3),P(3)
       COMMON /PLACE/ X(100,3,14),V(100,3,14)
       COMMON /CONST/ G,CLOSE,M
        DO 1 I = 1,3
          W(I) = 0
    1     P(I) = 0
        TM = 0
        DO 2 I = 1,N
          TM = TM + M(I)
          DO 2 J = 1,3
            W(J) = W(J) + M(I)*X(I,J,L)
    2       P(J) = P(J) + M(I)*V(I,J,L)
        DO 3 J = 1,3
          W(J) = W(J)/TM
    3     P(J) = P(J)/TM
       RETURN
      END
      IMPLICIT REAL*8 (A-H,O-Z)
      LOGICAL PRANGE,ROTATE,DIVE
      LOGICAL ASIS
      INTEGER FANCY
      INTEGER DEVICE(10),CARDS,BLANK
      REAL*8 M(100)
      REAL*8 XMIN(3),XMAX(3),W(3),P(3)
      REAL XSIZE,YSIZE,B,BLOAT
      COMMON /PLOTIT/ ROTATE,DIVE,DEVICE,BLOAT
      COMMON /CONST/ G,CLOSE,M
      COMMON /PLACE/ X(100,3,14),V(100,3,14),A(100,3,14)
      COMMON /SCOPE/ IU,IV,UMIN,VMIN,US,VS
      COMMON LINPR,CARDS
      DATA BLANK/'    '/
      DIVE = .FALSE.
      DIVE = .TRUE.
      ASIS = .FALSE.
      CARDS = 5
      LINPR = 6
      IN = 10
      XSIZE = 9
      YSIZE = 4.75
      DEVICE(1) = BLANK
      BLOAT = 10/(0.5 + 7.1)
      WRITE (LINPR,1)
    1 FORMAT (' Star Trails.')
      IF (.NOT.DIVE) WRITE (LINPR,2)
    2 FORMAT (' Enter size, (4.75 or 10.5)')
      IF (.NOT.DIVE) READ (CARDS,*) XSIZE
      YSIZE = XSIZE
      IN = 10
      OPEN (IN,FILE="TCL.dat")
      READ (IN,*) N
      WRITE (LINPR,*) N," bodies."
      READ (IN,*) G
      WRITE (LINPR,*) G," gravitational constant."
      READ (IN,*) T1,DT
      WRITE (LINPR,*) T1,DT," Run time, time step."
      READ (IN,*) XMIN,XMAX
      DO 3 I = 1,N
        READ (IN,*) M(I),(X(I,J,1), J = 1,3),(V(I,J,1),J = 1,3)
        DO 3 J = 1,3
          A(I,J,1) = 0
    3   CONTINUE
      CLOSE (IN)
c      WRITE (LINPR,4) N
      IST = 1
      LST = 3
    4 FORMAT (' The first and last body to show (of',I3,')')
c      READ (CARDS,*) IST,LST
      FANCY = 1
      WRITE (LINPR,5)
    5 FORMAT (' Euler/2''nd/Runge/Milne (1/2/3/4)')
      READ (CARDS,*) FANCY
c      WRITE (LINPR,6)
c    6 FORMAT (' Centre of mass (T/F)')
c      READ (CARDS,*) ASIS
      ASIS = .NOT.ASIS
C
   10 DO 11 I = 1,3
        IF (XMIN(I) .GE. XMAX(I)) GO TO 12
   11   CONTINUE
      GO TO 15
   12 DO 13 I = 1,3
        XMIN(I) = X(1,I,1)
   13   XMAX(I) = X(1,I,1)
      DO 14 I = 1,N
         DO 14 J = 1,3
           XMIN(J) = DMIN1(XMIN(J),X(I,J,1))
   14      XMAX(J) = DMAX1(XMAX(J),X(I,J,1))
   15 CLOSE = 0
      DO 16 I = 1,3
   16   CLOSE = CLOSE + (XMAX(I) - XMIN(I))**2
      IF (ASIS) GO TO 20
      CALL COM(N,1,TM,W,P)
      DO 17 I = 1,N
        DO 17 J = 1,3
   17     V(I,J,1) = V(I,J,1) - P(J)
C
   20 IU = 1
      IV = 2
      UMIN = XMIN(IU)
      VMIN = XMIN(IV)
      B = 0.5
      US = (XSIZE - 0)/(XMAX(IU) - UMIN)
      VS = (YSIZE - 0)/(XMAX(IV) - VMIN)
      IF (.NOT.PRANGE(-B,XSIZE + B,-B,YSIZE + B)) STOP
      CALL DOBOX(0.0,0.0,XSIZE,YSIZE)
C
  100 T0 = 0
      T = T0
      NSTEP = T1/DT + 0.5
      IF (IST .LE. LST) WRITE (LINPR,101)
  101 FORMAT (8X,'x       y       z       R',
     1 9X,'vx      vy      vz       V')
      IF (IST .LE. LST) CALL PRINT(X,V,IST,LST)
      IF (FANCY .EQ. 4) GO TO 200
      I1 = 1
      I2 = 2
      DO 110 I = 1,NSTEP
        IF (FANCY .EQ. 1) CALL EULER(I1,I2,N,T,DT)
        IF (FANCY .EQ. 2) CALL LUNGE(I1,I2,N,T,DT)
        IF (FANCY .EQ. 3) CALL RUNGE(I1,I2,N,T,DT)
        WRITE (LINPR,*) "T=",T
        CALL JOIN(I1,I2,N)
        CALL SWAPI(I1,I2)
        IF (IST .LE. LST) CALL PRINT(X(1,1,I1),V(1,1,I1),1,N)
  110   CONTINUE
      GO TO 9000
C
  200 EPS = 1
  201 EPS = EPS/2
      IF (1 + EPS .NE. 1) GO TO 201
      EPS = EPS*2
      CALL MILNE(N,T,T1,DT,EPS,NSTEP)
C
 9000 IF (FANCY .NE. 4) CALL PLOTXY(0.0,0.0,999)
      WRITE (LINPR,*) "Reached T=",T
      WRITE (LINPR,*) "Target  T=",T1
      WRITE (LINPR,*) "Time step=",DT,"Nstep=",NSTEP
      IF (FANCY .NE. 4) CALL PRINT(X(1,1,I1),V(1,1,I1),1,N)
      CLOSE = DSQRT(CLOSE)
      WRITE (LINPR,9001) CLOSE
 9001 FORMAT (' Closest approach:',E15.6)
      END
