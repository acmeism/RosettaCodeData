import: mapping

Integer method: properDivs -- []
   #[ self swap mod 0 == ] self 2 / seq filter ;

: amicables
| i j |
   Array new
   20000 loop: i [
      i properDivs sum dup ->j i <= if continue then
      j properDivs sum i <> if continue then
      [ i, j ] over add
      ]
;
