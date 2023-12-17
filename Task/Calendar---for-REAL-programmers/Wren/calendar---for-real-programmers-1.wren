IMPORT "./DATE" FOR DATE
IMPORT "./FMT" FOR FMT
IMPORT "./SEQ" FOR LST

VAR CALENDAR = FN.NEW { |YEAR|
    VAR SNOOPY = "🐶"
    VAR DAYS = "SU MO TU WE TH FR SA"
    VAR MONTHS = [
        "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE",
        "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"
    ]
    FMT.PRINT("$70M", SNOOPY)
    VAR YEARSTR = "--- %(YEAR) ---"
    FMT.PRINT("$70M\N", YEARSTR)
    VAR FIRST = LIST.FILLED(3, 0)
    VAR MLEN = LIST.FILLED(3, 0)
    VAR C = 0
    FOR (CHUNK IN LST.CHUNKS(MONTHS, 3)) {
        FOR (I IN 0..2) FMT.WRITE("$20M     ", CHUNK[I])
        SYSTEM.PRINT()
        FOR (I IN 0..2) SYSTEM.WRITE("%(DAYS)     ")
        SYSTEM.PRINT()
        FIRST[0] = DATE.NEW(YEAR, C*3 + 1, 1).DAYOFWEEK % 7
        FIRST[1] = DATE.NEW(YEAR, C*3 + 2, 1).DAYOFWEEK % 7
        FIRST[2] = DATE.NEW(YEAR, C*3 + 3, 1).DAYOFWEEK % 7
        MLEN[0]  = DATE.MONTHLENGTH(YEAR, C*3 + 1)
        MLEN[1]  = DATE.MONTHLENGTH(YEAR, C*3 + 2)
        MLEN[2]  = DATE.MONTHLENGTH(YEAR, C*3 + 3)
        FOR (I IN 0..5) {
            FOR (J IN 0..2) {
                VAR START = 1 + 7 * I - FIRST[J]
                FOR (K IN START..START+6) {
                    IF (K >= 1 && K <= MLEN[J]) {
                        FMT.WRITE("$2D ", K)
                    } ELSE {
                        SYSTEM.WRITE("   ")
                    }
                }
                SYSTEM.WRITE("    ")
            }
            SYSTEM.PRINT()
        }
        SYSTEM.PRINT()
        C = C + 1
    }
}

CALENDAR.CALL(1969)
