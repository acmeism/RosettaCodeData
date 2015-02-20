# Contains only five floors. 5! = 120 permutations.
for [1..5].permutations -> $b, $c, $f, $m, $s {
    say "Baker=$b Cooper=$c Fletcher=$f Miller=$m Smith=$s"
        if  $b != 5         # Baker    !live  on top floor.
        and $c != 1         # Cooper   !live  on bottom floor.
        and $f != 1|5       # Fletcher !live  on top or the bottom floor.
        and $m  > $c        # Miller    lives on a higher floor than Cooper.
        and $s != $f-1|$f+1 # Smith    !live  adjacent to Fletcher
        and $f != $c-1|$c+1 # Fletcher !live  adjacent to Cooper
    ;
}
