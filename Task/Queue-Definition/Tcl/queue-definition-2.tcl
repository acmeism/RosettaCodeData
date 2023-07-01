package require struct::queue
struct::queue Q
Q size ;# ==> 0
Q put a b c d e
Q size ;# ==> 5
Q peek ;# ==> a
Q get ;# ==> a
Q peek ;# ==> b
Q pop 4 ;# ==> b c d e
Q size ;# ==> 0
