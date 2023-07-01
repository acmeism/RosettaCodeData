const <- function(f) {function(d) f}
zero <- const(identity)
one <- identity
succ <- function(n) {function(f) {function(x) f(n(f)(x))}}
add <- function(n) {function(m) {function(f) {function(x) m(f)(n(f)(x))}}}
mult <- function(n) {function(m) {function(f) m(n(f))}}
expt <- function(n) {function(m) m(n)}
iszero <- function(n) n(const(zero))(one)
pred <- function(n) {function(f) {function(x)
    n(function(g) {function(h) h(g(f))})(const(x))(identity)}}
subt <- function(m) {function(n) n(pred)(m)}
divr <- function(n) {function(d)
    (function(v) v(const(succ(divr(v)(d))))(zero))(subt(n)(d))}
div <- function(dvdnd) {function(dvsr) divr(succ(dvdnd))(dvsr)}
natToChurch <- function(n) {if(n == 0) zero else succ(natToChurch(n - 1))}
churchToNat <- function(n) {(n(function(x) x + 1))(0)}

three <- natToChurch(3)
four <- succ(three)
eleven <- natToChurch(11)
twelve <- succ(eleven)

churchToNat(add(three)(four))
churchToNat(mult(three)(four))
churchToNat(expt(three)(four))
churchToNat(expt(four)(three))
churchToNat(iszero(zero))
churchToNat(iszero(three))
churchToNat(pred(four))
churchToNat(pred(zero))
churchToNat(subt(eleven)(three))
churchToNat(div(eleven)(three))
churchToNat(div(twelve)(three))
