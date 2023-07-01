# syntax: GAWK -f FIND_LIMIT_OF_RECURSION.AWK
#
# version             depth  messages
# ------------------  -----  --------
# GAWK 3.1.4           2892  none
# XML GAWK 3.1.4       3026  none
# GAWK 4.0          >999999
# MAWK 1.3.3           4976  A stack overflow was encountered at
#                            address 0x7c91224e.
# TAWK-DOS AWK 5.0c     357  stack overflow
# TAWK-WIN AWKW 5.0c   2477  awk stack overflow
# NAWK 20100523        4351  Segmentation fault (core dumped)
#
BEGIN {
    x()
    print("done")
}
function x() {
    print(++n)
    if (n > 999999) { return }
    x()
}
