$PROGRAM = '\'

MY @START_DOW = (3, 6, 6, 2, 4, 0,
                 2, 5, 1, 3, 6, 1);
MY @DAYS = (31, 28, 31, 30, 31, 30,
            31, 31, 30, 31, 30, 31);

MY @MONTHS;
FOREACH MY $M (0 .. 11) {
    FOREACH MY $R (0 .. 5) {
        $MONTHS[$M][$R] = JOIN " ",
            MAP { $_ < 1 || $_ > $DAYS[$M] ? "  " : SPRINTF "%2D", $_ }
            MAP { $_ - $START_DOW[$M] + 1 }
            $R * 7 .. $R * 7 + 6;
    }
}

SUB P { WARN $_[0], "\\N" }
P UC "                                                       [INSERT SNOOPY HERE]";
P "                                                               1969";
P "";
FOREACH (UC("      JANUARY               FEBRUARY               MARCH                 APRIL                  MAY                   JUNE"),
         UC("        JULY                 AUGUST              SEPTEMBER              OCTOBER               NOVEMBER              DECEMBER")) {
    P $_;
    MY @MS = SPLICE @MONTHS, 0, 6;
    P JOIN "  ", ((UC "SU MO TU WE TH FR SA") X 6);
    P JOIN "  ", MAP { SHIFT @$_ } @MS FOREACH 0 .. 5;
}

\'';

# LOWERCASE LETTERS
$E = '%' | '@';
$C = '#' | '@';
$H = '(' | '@';
$O = '/' | '@';
$T = '4' | '@';
$R = '2' | '@';
$A = '!' | '@';
$Z = ':' | '@';
$P = '0' | '@';
$L = ',' | '@';

`${E}${C}${H}${O} $PROGRAM | ${T}${R} A-Z ${A}-${Z} | ${P}${E}${R}${L}`;
