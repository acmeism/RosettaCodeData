USING: calendar formatting io kernel locals math math.ranges
sequences ;

! Calculate Easter.
:: my-easter ( year -- timestamp )
    year 19 mod                      :> a
    year 100 /i                      :> b
    year 100 mod                     :> c
    b 4 /i                           :> d
    b 4 mod                          :> e
    b 8 + 25 /i                      :> f
    b f - 1 + 3 /i                   :> g
    19 a * b + d - g - 15 + 30 mod   :> h
    c 4 /i                           :> i
    c 4 mod                          :> k
    32 2 e * + 2 i * + h - k - 7 mod :> l
    a 11 h * + 22 l * + 451 /i       :> m
    h l + 7 m * - 114 +              :> n
    n 31 /i                          :> month
    n 31 mod 1 +                     :> day
    year month day <date> ;

: show-related ( timestamp days-offset -- )
    days time+ "   %d %b   " strftime write ;

: holidays ( from to step -- )
    "Year     Easter      Ascension   Pentecost   Trinity     Corpus" print
    <range> [
        dup "%4d: " printf my-easter
        { 0 39 49 56 60 } [ show-related ] with each nl
    ] each ;

400 2100 100 holidays nl
2010 2020 1 holidays
