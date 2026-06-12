gcd_euclid <- function(a,b){
  if(b==0) abs(a)
  else gcd_euclid(b, a%%b)
}

lcm_euclid <- function(a,b) a*b/gcd_euclid(a,b)

Reduce(lcm_euclid, 1:20)
