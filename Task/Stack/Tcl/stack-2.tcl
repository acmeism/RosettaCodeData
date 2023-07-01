package require struct::stack
struct::stack S
S size ;# ==> 0
S push a b c d e
S size ;# ==> 5
S peek ;# ==> e
S pop ;# ==> e
S peek ;# ==> d
S pop 4 ;# ==> d c b a
S size ;# ==> 0
