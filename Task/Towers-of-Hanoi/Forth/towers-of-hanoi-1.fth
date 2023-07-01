CREATE peg1 ," left "
CREATE peg2 ," middle "
CREATE peg3 ," right "

: .$   COUNT TYPE ;
: MOVE-DISK
  LOCALS| via to from n |
  n 1 =
  IF   CR ." Move disk from " from .$ ." to " to .$
  ELSE n 1- from via to RECURSE
       1    from to via RECURSE
       n 1- via to from RECURSE
  THEN ;
