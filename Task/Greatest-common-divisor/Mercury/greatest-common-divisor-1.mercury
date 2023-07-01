:- module gcd.

:- interface.
:- import_module integer.

:- func gcd(integer, integer) = integer.

:- implementation.

:- pragma memo(gcd/2).
gcd(A, B) = (if B = integer(0) then A else gcd(B, A mod B)).
