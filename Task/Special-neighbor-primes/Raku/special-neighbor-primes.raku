# 20210809 Raku programming solution

for (grep {.is-prime}, 3..*).rotor(2 => -1) -> (\P1,\P2) {
   last if P2 ≥ Ⅽ;
   ($_ = P1+P2-1).is-prime and printf "%2d, %2d => %3d\n", P1, P2, $_
}
