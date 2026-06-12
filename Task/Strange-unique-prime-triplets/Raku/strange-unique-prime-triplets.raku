# 20210312 Raku programming solution

for 30, 1000 -> \k {
   given (2..k).grep(*.is-prime).combinations(3).grep(*.sum.is-prime) {
      say "Found ", +$_, " strange unique prime triplets up to ", k
   }
}
