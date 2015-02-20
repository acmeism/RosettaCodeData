blocks := "
(
BO
XK
DQ
CP
NA
GT
RE
TG
QD
FS
JW
HU
VI
AN
OB
ER
FS
LY
PC
ZM
)"

wordlist := "
(
A
BARK
BOOK
TREAT
COMMON
SQUAD
CONFUSE
)"

loop, parse, wordlist, `n
	out .= A_LoopField " - " isWordPossible(blocks, A_LoopField) "`n"
msgbox % out
