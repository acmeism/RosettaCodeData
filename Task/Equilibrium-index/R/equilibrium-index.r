is_equilibrium <- function(v, n){
  lower <- sum(v[seq_along(v)<n])
  higher <- sum(v[seq_along(v)>n])
  lower==higher
}

all_equilibriums <- function(v) Filter(function(n) is_equilibrium(v, n), seq_along(v))

all_equilibriums(c(-7,1,5,2,-4,3,0))
