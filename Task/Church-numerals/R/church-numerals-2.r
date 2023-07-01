zeroAlt <- function(x) identity
one <- function(f) f #Not actually requested by the task and only used to define Alt functions, so placed here.
oneAlt <- identity
succAlt <- function(n) {function(f) {function(x) n(f)(f(x))}}
succAltAlt <- add(one)
addAlt <- function(n) n(succ)
multAlt <- function(n) {function(m) m(add(n))(zero)}
exptAlt <- function(n) {function(m) m(mult(n))(one)}
