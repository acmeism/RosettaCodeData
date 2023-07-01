       MODULE DATEGNASH

       TYPE DATEBAG
        INTEGER DAY,MONTH,YEAR
       END TYPE DATEBAG

       CHARACTER*9 MONTHNAME(12),DAYNAME(0:6)
       PARAMETER (MONTHNAME = (/"JANUARY","FEBRUARY","MARCH","APRIL",
     1  "MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER",
     2  "DECEMBER"/))
       PARAMETER (DAYNAME = (/"SUNDAY","MONDAY","TUESDAY","WEDNESDAY",
     1  "THURSDAY","FRIDAY","SATURDAY"/))

       INTEGER*4 JDAYSHIFT
       PARAMETER (JDAYSHIFT = 2415020)
       CONTAINS
       INTEGER FUNCTION LSTNB(TEXT)
        CHARACTER*(*),INTENT(IN):: TEXT
        INTEGER L
         L = LEN(TEXT)
    1    IF (L.LE.0) GO TO 2
         IF (ICHAR(TEXT(L:L)).GT.ICHAR(" ")) GO TO 2
         L = L - 1
         GO TO 1
    2    LSTNB = L
        RETURN
       END FUNCTION LSTNB
      CHARACTER*2 FUNCTION I2FMT(N)
       INTEGER*4 N
        IF (N.LT.0) THEN
          IF (N.LT.-9) THEN
            I2FMT = "-!"
           ELSE
            I2FMT = "-"//CHAR(ICHAR("0") - N)
          END IF
        ELSE IF (N.LT.10) THEN
          I2FMT = " " //CHAR(ICHAR("0") + N)
        ELSE IF (N.LT.100) THEN
          I2FMT = CHAR(N/10      + ICHAR("0"))
     1           //CHAR(MOD(N,10) + ICHAR("0"))
        ELSE
          I2FMT = "+!"
        END IF
      END FUNCTION I2FMT
      CHARACTER*8 FUNCTION I8FMT(N)
       INTEGER*4 N
       CHARACTER*8 HIC
        WRITE (HIC,1) N
    1   FORMAT (I8)
        I8FMT = HIC
      END FUNCTION I8FMT

      SUBROUTINE SAY(OUT,TEXT)
       INTEGER OUT
       CHARACTER*(*) TEXT
        WRITE (6,1) TEXT(1:LSTNB(TEXT))
    1   FORMAT (A)
      END SUBROUTINE SAY

       INTEGER*4 FUNCTION DAYNUM(YY,M,D)
        INTEGER*4 JDAYN
        INTEGER YY,Y,M,MM,D
         Y = YY
         IF (Y.LT.1) Y = Y + 1
         MM = (M - 14)/12
         JDAYN = D - 32075
     A    + 1461*(Y + 4800  + MM)/4
     B    +  367*(M - 2     - MM*12)/12
     C    -    3*((Y + 4900 + MM)/100)/4
         DAYNUM = JDAYN - JDAYSHIFT
       END FUNCTION DAYNUM

       TYPE(DATEBAG) FUNCTION MUNYAD(DAYNUM)
        INTEGER*4 DAYNUM,JDAYN
        INTEGER Y,M,D,L,N
         JDAYN = DAYNUM + JDAYSHIFT
         L = JDAYN + 68569
         N = 4*L/146097
         L = L - (146097*N + 3)/4
         Y = 4000*(L + 1)/1461001
         L = L - 1461*Y/4 + 31
         M = 80*L/2447
         D = L - 2447*M/80
         L = M/11
         M = M + 2 - 12*L
         Y = 100*(N - 49) + Y + L
         IF (Y.LT.1) Y = Y - 1
         MUNYAD%YEAR  = Y
         MUNYAD%MONTH = M
         MUNYAD%DAY   = D
       END FUNCTION MUNYAD

       INTEGER FUNCTION PMOD(N,M)
        INTEGER N,M
         PMOD = MOD(MOD(N,M) + M,M)
       END FUNCTION PMOD

      SUBROUTINE CALENDAR(Y1,Y2,COLUMNS)

       INTEGER Y1,Y2,YEAR
       INTEGER M,M1,M2,MONTH
       INTEGER*4 DN1,DN2,DN,D
       INTEGER W,G
       INTEGER L,LINE
       INTEGER COL,COLUMNS,COLWIDTH
       CHARACTER*200 STRIPE(6),SPECIAL(6),MLINE,DLINE
        W = 3
        G = 1
        COLWIDTH = 7*W + G
      Y:DO YEAR = Y1,Y2
          CALL SAY(MSG,"")
          IF (YEAR.EQ.0) THEN
            CALL SAY(MSG,"THERE IS NO YEAR ZERO.")
            CYCLE Y
          END IF
          MLINE = ""
          L = (COLUMNS*COLWIDTH - G - 8)/2
          IF (YEAR.GT.0) THEN
            MLINE(L:) = I8FMT(YEAR)
           ELSE
            MLINE(L - 1:) = I8FMT(-YEAR)//"BC"
          END IF
          CALL SAY(MSG,MLINE)
          DO MONTH = 1,12,COLUMNS
            M1 = MONTH
            M2 = MIN(12,M1 + COLUMNS - 1)
            MLINE = ""
            DLINE = ""
            STRIPE = ""
            SPECIAL = ""
            L0 = 1
            DO M = M1,M2
              L = (COLWIDTH - G - LSTNB(MONTHNAME(M)))/2 - 1
              MLINE(L0 + L:) = MONTHNAME(M)
              DO D = 0,6
                L = L0 + (3 - W) + D*W
                DLINE(L:L + 2) = DAYNAME(D)(1:W - 1)
              END DO
              DN1 = DAYNUM(YEAR,M,1)
              DN2 = DAYNUM(YEAR,M + 1,0)
              COL = MOD(PMOD(DN1,7) + 7,7)
              LINE = 1
              D = 1
              DO DN = DN1,DN2
                L = L0 + COL*W
                STRIPE(LINE)(L:L + 1) = I2FMT(D)
                D = D + 1
                COL = COL + 1
                IF (COL.GT.6) THEN
                  LINE = LINE + 1
                  COL = 0
                END IF
              END DO
              L0 = L0 + 7*W + G
            END DO
            CALL SAY(MSG,MLINE)
            CALL SAY(MSG,DLINE)
            DO LINE = 1,6
              IF (STRIPE(LINE).NE."") THEN
                CALL SAY(MSG,STRIPE(LINE))
              END IF
            END DO
          END DO
        END DO Y
        CALL SAY(MSG,"")
      END SUBROUTINE CALENDAR
      END MODULE DATEGNASH

      PROGRAM SHOW1968
       USE DATEGNASH
       INTEGER NCOL
        DO NCOL = 1,6
          CALL CALENDAR(1969,1969,NCOL)
        END DO
      END
