Rebol [
    title: "Rosetta code: Periodic table"
    file:  %Periodic_table.r3
    url:   https://rosettacode.org/wiki/Periodic_table
]

periodic-table: function [
    "Returns the position of an element in the periodic table"
    n [integer!]
][
    assert [all [n >= 1 n <= 118]  "Atomic number is out of range"]
    case [
        n = 1 [return 1x1 ]
        n = 2 [return 1x18]
        all [n >= 57 n <= 71]  [return as-pair 8 n - 53]  ;; lanthanides
        all [n >= 89 n <= 103] [return as-pair 9 n - 85]  ;; actinides
    ]
    row: 2
    foreach [s e] [
        3  10  ;; row 2
        11 18  ;; row 3
        19 36  ;; row 4
        37 54  ;; row 5
        55 86  ;; row 6
        87 118 ;; row 7
    ][
        if all [n >= s  n <= e] [
            return either any [n < (s + 2)  row = 4  row = 5] [
                as-pair row n - s  + 1
            ][  as-pair row n - e + 18 ]
        ]
        ++ row
    ]
]

foreach n [1 2 29 42 57 58 59 71 72 89 90 103 113] [
    rc: periodic-table n
    print [pad n 3 "->" rc]
]

draw-periodic-table: function [
    "Draws the periodic table in terminal using element symbols"
][
    symbols: [
        H  He Li Be B  C  N  O  F  Ne
        Na Mg Al Si P  S  Cl Ar K  Ca
        Sc Ti V  Cr Mn Fe Co Ni Cu Zn
        Ga Ge As Se Br Kr Rb Sr Y  Zr
        Nb Mo Tc Ru Rh Pd Ag Cd In Sn
        Sb Te I  Xe Cs Ba La Ce Pr Nd
        Pm Sm Eu Gd Tb Dy Ho Er Tm Yb
        Lu Hf Ta W  Re Os Ir Pt Au Hg
        Tl Pb Bi Po At Rn Fr Ra Ac Th
        Pa U  Np Pu Am Cm Bk Cf Es Fm
        Md No Lr Rf Db Sg Bh Hs Mt Ds
        Rg Cn Nh Fl Mc Lv Ts Og
    ]

    grid: array 9 * 18        ;; 9 rows x 18 cols (rows 8-9 = lanthanides/actinides)

    repeat n 118 [
        rc: periodic-table n
        grid/(rc/x - 1 * 18 + rc/y): n
    ]

    print-hline/width 70
    repeat row 9 [
        if row = 8 [print ""] ;; blank line before lanthanides/actinides
        repeat col 18 [
            n: grid/(row - 1 * 18 + col)
            prin either n [ pad symbols/:n 4 ][ "    " ]
        ]
        print ""
    ]
    print-hline/width 70
]

draw-periodic-table
