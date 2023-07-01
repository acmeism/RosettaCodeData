PACKAGE MAIN

IMPORT (
    "FMT"
    "TIME"
)

CONST PAGEWIDTH = 80

FUNC MAIN() {
    PRINTCAL(1969)
}

FUNC PRINTCAL(YEAR INT) {
    THISDATE := TIME.DATE(YEAR, 1, 1, 1, 1, 1, 1, TIME.UTC)
    VAR (
        DAYARR                  [12][7][6]INT // MONTH, WEEKDAY, WEEK
        MONTH, LASTMONTH        TIME.MONTH
        WEEKINMONTH, DAYINMONTH INT
    )
    FOR THISDATE.YEAR() == YEAR {
        IF MONTH = THISDATE.MONTH(); MONTH != LASTMONTH {
            WEEKINMONTH = 0
            DAYINMONTH = 1
        }
        WEEKDAY := THISDATE.WEEKDAY()
        IF WEEKDAY == 0 && DAYINMONTH > 1 {
            WEEKINMONTH++
        }
        DAYARR[INT(MONTH)-1][WEEKDAY][WEEKINMONTH] = THISDATE.DAY()
        LASTMONTH = MONTH
        DAYINMONTH++
        THISDATE = THISDATE.ADD(TIME.HOUR * 24)
    }
    CENTRE := FMT.SPRINTF("%D", PAGEWIDTH/2)
    FMT.PRINTF("%"+CENTRE+"S\N\N", "[SNOOPY]")
    CENTRE = FMT.SPRINTF("%D", PAGEWIDTH/2-2)
    FMT.PRINTF("%"+CENTRE+"D\N\N", YEAR)
    MONTHS := [12]STRING{
        " JANUARY ", " FEBRUARY", "  MARCH  ", "  APRIL  ",
        "   MAY   ", "   JUNE  ", "   JULY  ", "  AUGUST ",
        "SEPTEMBER", " OCTOBER ", " NOVEMBER", " DECEMBER"}
    DAYS := [7]STRING{"SU", "MO", "TU", "WE", "TH", "FR", "SA"}
    FOR QTR := 0; QTR < 4; QTR++ {
        FOR MONTHINQTR := 0; MONTHINQTR < 3; MONTHINQTR++ { // MONTH NAMES
            FMT.PRINTF("      %S           ", MONTHS[QTR*3+MONTHINQTR])
        }
        FMT.PRINTLN()
        FOR MONTHINQTR := 0; MONTHINQTR < 3; MONTHINQTR++ { // DAY NAMES
            FOR DAY := 0; DAY < 7; DAY++ {
                FMT.PRINTF(" %S", DAYS[DAY])
            }
            FMT.PRINTF("     ")
        }
        FMT.PRINTLN()
        FOR WEEKINMONTH = 0; WEEKINMONTH < 6; WEEKINMONTH++ {
            FOR MONTHINQTR := 0; MONTHINQTR < 3; MONTHINQTR++ {
                FOR DAY := 0; DAY < 7; DAY++ {
                    IF DAYARR[QTR*3+MONTHINQTR][DAY][WEEKINMONTH] == 0 {
                        FMT.PRINTF("   ")
                    } ELSE {
                        FMT.PRINTF("%3D", DAYARR[QTR*3+MONTHINQTR][DAY][WEEKINMONTH])
                    }
                }
                FMT.PRINTF("     ")
            }
            FMT.PRINTLN()
        }
        FMT.PRINTLN()
    }
}
