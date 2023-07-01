c-library crypto

s" ssl" add-lib
s" crypto" add-lib

\c #include <openssl/sha.h>
c-function sha256 SHA256 a n a -- a

end-c-library

: 2h.  ( n1 -- )  base @ swap hex s>d <# # # #> type base ! ;

: .digest ( a -- )
    32 bounds do  i c@ 2h.  loop space ;

s" Rosetta code" 0 sha256 .digest cr
bye
