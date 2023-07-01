intersect_point <- function(ray_vec, ray_point, plane_normal, plane_point) {

  pdiff <- ray_point - plane_point
  prod1 <- pdiff %*% plane_normal
  prod2 <- ray_vec %*% plane_normal
  prod3 <- prod1 / prod2
  point <- ray_point - ray_vec * as.numeric(prod3)

  return(point)
}
