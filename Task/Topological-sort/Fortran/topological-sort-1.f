      SUBROUTINE TSORT(NL,ND,IDEP,IORD,IPOS,NO)
      IMPLICIT NONE
      INTEGER NL,ND,NO,IDEP(ND,2),IORD(NL),IPOS(NL),I,J,K,IL,IR,IPL,IPR
      DO 10 I=1,NL
      IORD(I)=I
   10 IPOS(I)=I
      K=1
   20 J=K
      K=NL+1
      DO 30 I=1,ND
      IL=IDEP(I,1)
      IR=IDEP(I,2)
      IPL=IPOS(IL)
      IPR=IPOS(IR)
      IF(IL.EQ.IR .OR. IPL.GE.K .OR. IPL.LT.J .OR. IPR.LT.J) GO TO 30
      K=K-1
      IPOS(IORD(K))=IPL
      IPOS(IL)=K
      IORD(IPL)=IORD(K)
      IORD(K)=IL
   30 CONTINUE
      IF(K.GT.J) GO TO 20
      NO=J-1
      END
