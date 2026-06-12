// Extra Primes. Nigel Galloway: January 9th., 2021
let izXprime g=let rec fN n g=match n with 0L->isPrime64 g |_->if isPrime64(n%10L) then fN (n/10L) (n%10L+g) else false in fN g 0L
