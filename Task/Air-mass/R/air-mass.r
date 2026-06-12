#Equation for height was worked out by hand using the cosine rule and quadratic formula
h <- function(a, z, x, r) -r + sqrt((a+r)^2 + x^2 + 2*x*(a+r)*cos(z))
rho <- function(a) exp(-a/8.5)

airmass_absolute <- function(a, z) {
  integrate(function(x) rho(h(a, z, x, 6371)), 0, 10000)$value
}
airmass_relative <- function(a) function(z) {
  airmass_absolute(a, z)/airmass_absolute(a, 0)
}

angles <- seq(from = 0, to = 90, by = 5)
call_angles <- function(f) sapply(angles*pi/180, f)

airmasses <- data.frame(
  "Angle" = angles,
  "a_0m" = call_angles(airmass_relative(0)),
  "a_13700m" = call_angles(airmass_relative(13.7))
) |> print(row.names = FALSE)
