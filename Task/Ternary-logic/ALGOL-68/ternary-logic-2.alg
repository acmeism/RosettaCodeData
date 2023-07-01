# -*- coding: utf-8 -*- #

OP & = (LOGICAL a,b)LOGICAL: a AND b;
CO # not included as they are treated as SCALAR #
OP EQ = (LOGICAL a,b)LOGICAL: a = b,
   NE = (LOGICAL a,b)LOGICAL: a /= b,
   ≠ = (TRIT a,b)TRIT: a /= b,
   ¬= = (TRIT a,b)TRIT: a /= b;
END CO

#IF html entities possible THEN
¢ "parked" operators for completeness ¢
OP ¬ = (LOGICAL a)LOGICAL: NOT a,
   ∧  = (LOGICAL a,b)LOGICAL: a AND b,
   /\ = (LOGICAL a,b)LOGICAL: a AND b,
   ∨  = (LOGICAL a,b)LOGICAL: a OR b,
   \/ = (LOGICAL a,b)LOGICAL: a OR b,
   ⊃ = (TRIT a,b)TRIT: a IMPLIES b,
   ≡ = (TRIT a,b)TRIT: a EQV b;
FI#

#IF algol68c THEN
OP ~ = (LOGICAL a)LOGICAL: NOT a,
   ~= = (LOGICAL a,b)LOGICAL: a /= b; SCALAR!
FI#
