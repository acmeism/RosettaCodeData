\ string words operate on the address and count left on the stack by a string
\ ? means the word returns a true/false flag on the stack

: empty? ( c-addr u -- ? ) nip 0= ;
: filled?  ( c-addr u -- ? ) empty? 0= ;
: =""      ( c-addr u -- ) drop 0 ;  \ It's OK to copy syntax from other languages
