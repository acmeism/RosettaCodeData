point_in_polygon <- function(polygon, p) {
  count <- 0
  for(side in polygon) {
    if ( ray_intersect_segment(p, side) ) {
      count <- count + 1
    }
  }
  if ( count %% 2 == 1 )
    "INSIDE"
  else
    "OUTSIDE"
}

ray_intersect_segment <- function(p, side) {
  eps <- 0.0001
  a <- side$A
  b <- side$B
  if ( a$y > b$y ) {
    a <- side$B
    b <- side$A
  }
  if ( (p$y == a$y) || (p$y == b$y) ) {
    p$y <- p$y + eps
  }
  if ( (p$y < a$y) || (p$y > b$y) )
    return(FALSE)
  else if ( p$x > max(a$x, b$x) )
    return(FALSE)
  else {
    if ( p$x < min(a$x, b$x) )
      return(TRUE)
    else {
      if ( a$x != b$x )
        m_red <- (b$y - a$y) / (b$x - a$x)
      else
        m_red <- Inf
      if ( a$x != p$x )
        m_blue <- (p$y - a$y) / (p$x - a$x)
      else
        m_blue <- Inf
      return( m_blue >= m_red )
    }
  }
}
