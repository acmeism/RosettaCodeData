euler <- function(f, y0, a, b, h)
{
  t <- a
  y <- y0

  while (t < b)
  {
    cat(sprintf("%6.3f %6.3f\n", t, y))
    t <- t + h
    y <- y + h*f(t, y)
  }
}

newtoncooling <- function(time, temp){
  return(-0.07*(temp-20))
  }

euler(newtoncooling, 100, 0, 100, 10)
