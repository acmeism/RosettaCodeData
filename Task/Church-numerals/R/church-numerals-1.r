zero <- function(f) {function(x) x}
succ <- function(n) {function(f) {function(x) f(n(f)(x))}}
add <- function(n) {function(m) {function(f) {function(x) m(f)(n(f)(x))}}}
mult <- function(n) {function(m) {function(f) m(n(f))}}
expt <- function(n) {function(m) m(n)}
natToChurch <- function(n) {if(n == 0) zero else succ(natToChurch(n - 1))}
churchToNat <- function(n) {(n(function(x) x + 1))(0)}

three <- natToChurch(3)
four <- natToChurch(4)

churchToNat(add(three)(four))
churchToNat(mult(three)(four))
churchToNat(expt(three)(four))
churchToNat(expt(four)(three))
