Y <- function(f) {
  (function(x) { (x)(x) })( function(y) { f( (function(a) {y(y)})(a) ) } )
}
