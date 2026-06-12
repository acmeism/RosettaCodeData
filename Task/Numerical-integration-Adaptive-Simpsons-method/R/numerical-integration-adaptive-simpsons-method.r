simpson_rule <- function(f, a, b, fa, fb){
  m <- (a+b)/2
  h <- b-a
  fm <- f(m)
  c((h/6)*(fa+4*fm+fb), m, fm)
}

recursive_simpson <- function(f, a, b, fa, fb, tol, whole, m, fm, depth){
  vleft <- simpson_rule(f, a, m, fa, fm)
  vright <- simpson_rule(f, m, b, fm, fb)
  delta <- vleft[1]+vright[1]-whole
  tol_new <- tol/2
  args_left <- as.list(c(f, a, m, fa, fm, tol_new, vleft, depth-1))
  args_right <- as.list(c(f, m, b, fm, fb, tol_new, vright, depth-1))
  ifelse(depth<=0|tol==tol_new|abs(delta)<=15*tol,
         vleft[1]+vright[1]+delta/15,
         do.call(recursive_simpson, args_left)+do.call(recursive_simpson, args_right))
}

quad_asr <- function(f, a, b, tol, depth){
  fa <- f(a)
  fb <- f(b)
  vwhole <- simpson_rule(f, a, b, fa, fb)
  args_whole <- as.list(c(f, a, b, fa, fb, tol, vwhole, depth))
  do.call(recursive_simpson, args_whole)
}

print(quad_asr(sin, 0, 1, 10^-9, 10), digits=9)
