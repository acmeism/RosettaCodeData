C     ------------------------------------------------------------------
      PROGRAM BIORHYTHM
C     ------------------------------------------------------------------
      DOUBLE PRECISION GETJD
      CHARACTER*3 DOW

      DOUBLE PRECISION JD0, JD1, JD2, PI2, DIF

      INTEGER BYEAR, BMON, BDAY, TYEAR, TMON, TDAY
      INTEGER I, J, PHY, EMO, MEN, NDAY, DNUM, YR, DOY
      CHARACTER*3 DNAME
      CHARACTER*1 GRID, ROW(65)
C     ------------------------------------------------------------------

      PI2 = ACOS(-1.0D0)*2.0D0

      WRITE(*,*) 'ENTER YOUR BIRTHDAY YYYY MM DD'
      READ(*,*) BYEAR, BMON, BDAY

      WRITE(*,*) 'ENTER START DATE YYYY MM DD'
      READ(*,*) TYEAR, TMON, TDAY

      WRITE(*,*) 'ENTER NUMBER OF DAYS TO PLOT'
      READ(*,*) NDAY

      JD0 = GETJD( TYEAR, 1,  1 )
      JD1 = GETJD( BYEAR, BMON, BDAY )
      JD2 = GETJD( TYEAR, TMON, TDAY )

      WRITE(*,1010)
      WRITE(*,1000) DOW(JD1), INT( JD2-JD1 )
      WRITE(*,1010)
      WRITE(*,1020)
      DO I=1,NDAY
         DIF = JD2 - JD1
         PHY = INT(3.3D1+3.2D1*SIN( PI2 * DIF / 2.3D1 ))
         EMO = INT(3.3D1+3.2D1*SIN( PI2 * DIF / 2.8D1 ))
         MEN = INT(3.3D1+3.2D1*SIN( PI2 * DIF / 3.3D1 ))

         IF ( PHY.LT.1  ) PHY = 1
         IF ( EMO.LT.1  ) EMO = 1
         IF ( MEN.LT.1  ) MEN = 1
         IF ( PHY.GT.65 ) PHY = 65
         IF ( EMO.GT.65 ) EMO = 65
         IF ( MEN.GT.65 ) MEN = 65

         DNAME = DOW(JD2)
         DOY = INT(JD2-JD0)+1
         IF ( DNAME.EQ.'SUN' ) THEN
            GRID = '.'
         ELSE
            GRID = ' '
         END IF
         DO J=1,65
            ROW(J) = GRID
         END DO
         ROW(1)  = '|'
         ROW(17) = ':'
         ROW(33) = '|'
         ROW(49) = ':'
         ROW(65) = '|'
         ROW(PHY) = 'P'
         ROW(EMO) = 'E'
         ROW(MEN) = 'M'
         IF ( PHY.EQ.EMO ) ROW(PHY) = '*'
         IF ( PHY.EQ.MEN ) ROW(PHY) = '*'
         IF ( EMO.EQ.MEN ) ROW(EMO) = '*'
         WRITE(*,1030) ROW,DNAME,DOY
         JD2 = JD2 + 1.0D0
      END DO
      WRITE(*,1010)

C     ------------------------------------------------------------------

 1000 FORMAT( 'YOU WERE BORN ON A (', A3, ') YOU WERE ',I0,
     $        ' DAYS OLD AT THE START.' )
 1010 FORMAT( 75('=') )
 1020 FORMAT( '-1',31X,'0',30X,'+1     DOY' )
 1030 FORMAT( 1X,65A1, 1X, A3, 1X, I3 )

      STOP
      END

C     ------------------------------------------------------------------
      FUNCTION DOW( JD )
C     ------------------------------------------------------------------
C     RETURN THE ABBREVIATION FOR THE DAY OF THE WEEK
C     JD  JULIAN DATE - GREATER THAN 1721423.5 (JAN 1, 0001 SATURDAY)
C     ------------------------------------------------------------------
      DOUBLE PRECISION JD
      INTEGER IDX
      CHARACTER*3 DOW, NAMES(7)
      DATA NAMES/'SAT','SUN','MON','TUE','WED','THR','FRI'/

      IDX = INT(MODULO(JD-1.721423500D6,7.0D0)+1)

      DOW = NAMES(IDX)
      RETURN
      END

C     ------------------------------------------------------------------
      FUNCTION ISGREG( Y, M, D )
C     ------------------------------------------------------------------
C     IS THIS DATE ON IN THE GREGORIAN CALENDAR
C     DATES BEFORE OCT  5 1582 ARE JULIAN
C     DATES AFTER  OCT 14 1582 ARE GREGORIAN
C     DATES OCT 5-14 1582 INCLUSIVE DO NOT EXIST
C     ------------------------------------------------------------------
C     YEAR    1-ANYTHING
C     MONTH   1-12
C     DAY     1-31
C     ------------------------------------------------------------------
      LOGICAL ISGREG
      INTEGER Y, M, D
C     ------------------------------------------------------------------
      ISGREG=.TRUE.
      IF ( Y.LT.1582 ) GOTO 888
      IF ( Y.GT.1582 ) GOTO 999
      IF ( M.LT.10 )   GOTO 888
      IF ( M.GT.10 )   GOTO 999
      IF ( D.LT.5 )    GOTO 888
      IF ( D.GT.14 )   GOTO 999

      WRITE(*,*) Y,M,D,' DOES NOT EXIST'
      GOTO 999

 888  CONTINUE
      ISGREG=.FALSE.
 999  CONTINUE
      RETURN
      END

C     ------------------------------------------------------------------
      FUNCTION GETJD( YEAR, MONTH, DAY )
C     ------------------------------------------------------------------
C     RETURN THE JULIAN DATE
C     YEAR    1-ANYTHING
C     MONTH   1-12
C     DAY     1-31
C     ------------------------------------------------------------------
      DOUBLE PRECISION GETJD
      INTEGER YEAR, MONTH, DAY
      INTEGER Y, M, D, A, B, P1, P2
C     ------------------------------------------------------------------
      DOUBLE PRECISION TEMP
      LOGICAL ISGREG, IG

      IG = ISGREG( YEAR, MONTH, DAY )
      Y  = YEAR
      M  = MONTH
      D  = DAY

      IF (M.LT.3) THEN
         Y = Y - 1
         M = M + 12
      ENDIF

      IF (IG) THEN
         A =         FLOOR( DBLE(Y) * 1.0D-2 )
         B = 2 - A + FLOOR( DBLE(A) * 2.5D-1 )
      ELSE
         A = 0
         B = 0
      ENDIF

      P1 = FLOOR( 3.65250D2 * DBLE(Y + 4716) )
      P2 = FLOOR( 3.06001D1 * DBLE(M + 1) )

      GETJD = DBLE(P1 + P2 + D + B) - 1.5245D3

      RETURN
      END
