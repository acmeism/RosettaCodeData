# 20200511 Raku programming solution

use Grammar::ABNF;

grammar G is Grammar::ABNF { token CRLF { "\n" } };

my $g = G.generate(Q:to<RULES>
stmt         =          expr
expr         =          expr_level_2
expr_level_2 =          expr_level_3 *(      " or "       expr_level_3 )
expr_level_3 =          expr_level_4 *(      " and "      expr_level_4 )
expr_level_4 = ["not "] expr_level_5  [ [ " = " / " < " ] expr_level_5 ]
expr_level_5 =          expr_level_6 *( [ " + " / " - " ] expr_level_6 )
expr_level_6 =          primary      *( [ " * " / " / " ] primary )
Integer      =  Digit  *( Digit )
Identifier   =  Letter *( Letter / Digit / "_" )
primary      =  Identifier / Integer / "(" expr ")" / " true " / " false "
Digit        =  "0" / "1" / "2" / "3" / "4" / "5" / "6" / "7" / "8" / "9"
Letter       =  "a" / "b" / "c" / "d" / "e" / "f" / "g" / "h" / "i" / "j"
               / "k" / "l" / "m" / "n" / "o" / "p" / "q" / "r" / "s" / "t"
               / "u" / "v" / "w" / "x" / "y" / "z" / "A" / "B" / "C" / "D"
               / "E" / "F" / "G" / "H" / "I" / "J" / "K" / "L" / "M" / "N"
               / "O" / "P" / "Q" / "R" / "S" / "T" / "U" / "V" / "W" / "X"
               / "Y" / "Z"
RULES
);

my \DATA = Q:to<DATA>;
3 + not 5
3 + (not 5)
(42 + 3
(42 + 3 syntax_error
not 3 < 4 or (true or 3 / 4 + 8 * 5 - 5 * 2 < 56) and 4 * 3 < 12 or not true
and 3 < 2
not 7 < 2
2 < 3 < 4
2 < foobar - 3 < 4
2 < foobar and 3 < 4
4 * (32 - 16) + 9 = 73
235 76 + 1
a + b = not c and false
a + b = (not c) and false
a + b = (not c and false)
ab_c / bd2 or < e_f7
g not = h
i++
j & k
l or _m
UPPER_cAsE_aNd_letter_and_12345_test
DATA

say $g.parse($_).Bool, "\t", $_ for DATA.lines
