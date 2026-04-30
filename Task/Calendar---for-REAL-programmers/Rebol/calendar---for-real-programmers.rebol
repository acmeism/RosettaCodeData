Rebol [
    title: {Rosetta code: Calendar - for "REAL" programmers}
    file:  %Calendar_for_REAL_programmers.r3
    url:   https://rosettacode.org/wiki/Calendar_-_for_%22REAL%22_programmers
    note: "Based on Red language implementation!"
]
REAL-CALENDAR: FUNCTION/WITH [YEAR [INTEGER!]][
    PRINT CENTR "[ S N O O P Y ]" 130 ; PRINT SNOOPY BLOCK CENTERED
    PRINT CENTR TO-STRING Y 130 ; PRINT YEAR

    FOREACH R [[1 2 3 4 5 6][7 8 9 10 11 12]] [
        ; PRINT MONTH'S NAME
        FOREACH M R [
            PRIN REJOIN [CENTR UPPERCASE MONTHS/:M 21 " "]
        ] PRINT ""

        ; PRINT FOR EACH WEEK ACROSS MONTHS
        FOREACH W [0 1 2 3 4 5 6] [
            ; EACH MONTHS
            FOREACH M R [
                EITHER W = 0 [ ; PRINT WEEKDAYS
                    FOREACH D ["SU" "MO" "TU" "WE" "TH" "FR" "SA"]
                        [PRIN [FORM PAD D 3]]
                ] [
                    FOREACH WD [1 2 3 4 5 6 7] [ ; PRINT DATES
                        ; RECONSTRUCT THE DAY
                        EITHER 0 < DT: GETDAY Y M W WD [
                            PRIN [FORM PAD DT -2]
                        ] [
                            PRIN "  "
                        ] PRIN " "
                    ]
                ] PRIN " "
            ] PRINT ""
        ] PRINT ""
    ]
][
    MONTHS: SYSTEM/LOCALE/MONTHS
    ; GET DAY FROM YEAR, MONTH, WEEK, AND WEEKDAY!
    GETDAY: FUNCTION [Y[INTEGER!] M[INTEGER!] W[INTEGER!] WD[INTEGER!]] [
        FD: TO-DATE REDUCE [1 M Y] ; FIRST DAY!
        SWD: FD/WEEKDAY + 1  IF SWD > 7 [SWD: 1] ; SHIFT FROM MON=1 TO SUN=1
        OFS: (W - 1) * 7 + (WD - SWD) ; OFFSET
        D: FD + OFS ; DATE
        EITHER D/MONTH = M [D/DAY][0] ; RETURN DAY OR ZERO!
    ]

    ; CENTER STRING
    CENTR: FUNCTION [STR WID] [
        GAP: WID - LENGTH? STR
        LPAD: TO-INTEGER GAP / 2
        PAD STR NEGATE (WID - LPAD)
        PAD STR WID
    ]
]

;; DEMO:
REAL-CALENDAR 2015
