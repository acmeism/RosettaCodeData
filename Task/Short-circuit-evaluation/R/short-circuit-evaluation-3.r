switchop <- function(s, x, y) {
  if(s < 0) x || y
  else if (s > 0) x && y
  else xor(x, y)
}
