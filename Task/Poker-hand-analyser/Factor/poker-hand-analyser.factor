USING: formatting kernel poker sequences ;
{
    "2H 2D 2C KC QD"
    "2H 5H 7D 8C 9S"
    "AH 2D 3C 4C 5D"
    "2H 3H 2D 3C 3D"
    "2H 7H 2D 3C 3D"
    "2H 7H 7D 7C 7S"
    "TH JH QH KH AH"
    "4H 4S KS 5D TS"
    "QC TC 7C 6C 4C"
} [ dup string>hand-name "%s: %s\n" printf ] each
