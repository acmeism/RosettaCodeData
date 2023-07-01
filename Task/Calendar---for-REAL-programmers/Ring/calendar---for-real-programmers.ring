# PROJECT : CALENDAR - FOR "REAL" PROGRAMMERS
# DATE      : 2018/06/28
# AUTHOR : GAL ZSOLT (~ CALMOSOFT ~)
# EMAIL    : <CALMOSOFT@GMAIL.COM>

LOAD "GUILIB.RING"
LOAD "STDLIB.RING"

NEW QAPP
       {
        WIN1 = NEW QWIDGET() {
                   DAY = LIST(12)
                   POS = NEWLIST(12,37)
                   MONTH = LIST(12)
                   WEEK = LIST(7)
                   WEEKDAY = LIST(7)
                   BUTTON = NEWLIST(7,6)
                   MONTHSNAMES = LIST(12)
                   WEEK = ["SU", "MO", "TU", "WE", "TH", "FR", "SA"]
                   MONTHS = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY",
                                   "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]
                   DAYSNEW = [[5,1], [6,2], [7,3], [1,4], [2,5], [3,6], [4,7]]
                   MO = [4,0,0,3,5,1,3,6,2,4,0,2]
                   MON = [31,28,31,30,31,30,31,31,30,31,30,31]
                   M2 = (((1969-1900)%7) + FLOOR((1969 - 1900)/4) % 7) % 7
                   FOR N = 1 TO 12
                        MONTH[N] = (MO[N] + M2) % 7
                        X = (MONTH[N] + 1) % 7 + 1
                       FOR M = 1 TO LEN(DAYSNEW)
                            IF DAYSNEW[M][1] = X
                              NR = M
                           OK
                       NEXT
                       DAY[N] = DAYSNEW[NR][2]
                  NEXT
                  FOR M = 1 TO 12
                       FOR N = 1 TO DAY[M] - 1
                            POS[M][N] = "  "
                       NEXT
                  NEXT
                  FOR M = 1 TO 12
                       FOR  N = DAY[M] TO 37
                             IF N < (MON[M] + DAY[M])
                                POS[M][N] = N - DAY[M] + 1
                             ELSE
                                POS[M][N] = "  "
                             OK
                       NEXT
                  NEXT
                  SETWINDOWTITLE("CALENDAR")
                  SETGEOMETRY(100,100,650,800)
                  LABEL1 = NEW QLABEL(WIN1) {
                              SETGEOMETRY(10,10,800,600)
                              SETTEXT("")
                  }
                 YEAR = NEW QPUSHBUTTON(WIN1)
                                                  {
                                                  SETGEOMETRY(280,20,63,20)
                                                  YEAR.SETTEXT("1969")
                                                  }
                 FOR N = 1 TO 4
                      NR = (N-1)*3+1
                     SHOWMONTHS(NR)
                 NEXT
                 FOR N = 1 TO 12
                     SHOWWEEKS(N)
                 NEXT
                 FOR N = 1 TO 12
                     SHOWDAYS(N)
                 NEXT
                 SHOW()
        }
        EXEC()
        }

FUNC SHOWMONTHS(M)
       FOR N = M TO M + 2
            MONTHSNAMES[N] = NEW QPUSHBUTTON(WIN1)
                                        {
                                        IF N%3 = 1
                                           COL = 120
                                           ROWNR = FLOOR(N/3)
                                           IF ROWNR = 0
                                              ROWNR = N/3
                                           OK
                                           IF N = 1
                                              ROW = 40
                                           ELSE
                                              ROW = 40+ROWNR*180
                                           OK
                                        ELSE
                                           COLNR = N%3
                                           IF COLNR = 0
                                              COLNR = 3
                                           OK
                                           ROWNR = FLOOR(N/3)
                                           IF N%3 = 0
                                              ROWNR = FLOOR(N/3)-1
                                           OK
                                           COL = 120 + (COLNR-1)*160
                                           ROW = 40 + ROWNR*180
                                        OK
                                        SETGEOMETRY(COL,ROW,63,20)
                                        MONTHSNAMES[N].SETTEXT(MONTHS[N])
                                        }
       NEXT

FUNC SHOWWEEKS(N)
        FOR M = 1 TO 7
             COL = M%7
             IF COL = 0 COL = 7 OK
             WEEKDAY[M] = NEW QPUSHBUTTON(WIN1)
                                  {
                                  COLNR = N % 3
                                  IF COLNR = 0
                                     COLNR = 3
                                  OK
                                  ROWNR = FLOOR(N/3)
                                  IF N%3 = 0
                                     ROWNR = FLOOR(N/3)-1
                                  OK
                                  COLBEGIN = 60 + (COLNR-1)*160
                                  ROWBEGIN = 60 + (ROWNR)*180
                                  SETGEOMETRY(COLBEGIN+COL*20,ROWBEGIN,25,20)
                                  WEEKDAY[M].SETTEXT(WEEK[M])
                                  }
        NEXT

FUNC SHOWDAYS(IND)
        ROWNR = FLOOR(IND/3)
        IF IND%3 = 0
           ROWNR = FLOOR(IND/3)-1
        OK
        ROWBEGIN = 60+ROWNR*180
        FOR M = 1 TO 6
             FOR N = 1 TO 7
                  COL = N%7
                  IF COL = 0 COL = 7 OK
                  ROW = M
                   BUTTON[N][M] = NEW QPUSHBUTTON(WIN1)
                                         {
                                          IF IND%3 = 1
                                             COLBEGIN = 60
                                          ELSEIF IND%3 = 2
                                             COLBEGIN = 220
                                          ELSE
                                             COLBEGIN = 380
                                          OK
                                          SETGEOMETRY(COLBEGIN+COL*20,ROWBEGIN+ROW*20,25,20)
                                          NR = (M-1)*7+N
                                          IF NR <= 37
                                             IF POS[IND][NR] != "  "
                                                BUTTON[N][M].SETTEXT(STRING(POS[IND][NR]))
                                             OK
                                          OK
                                          }
             NEXT
        NEXT
