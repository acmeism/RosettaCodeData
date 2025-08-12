test_angles <- c(-2,-1,0,1,2,6.2831853,16,57.2957795,359,399,6399,1000000)

d2d <- function(a) sign(a)*(abs(a)%%360)
g2g <- function(a) sign(a)*(abs(a)%%400)
m2m <- function(a) sign(a)*(abs(a)%%6400)
r2r <- function(a) sign(a)*(abs(a)%%(2*pi))

normalised <- as.data.frame(sapply(c(d2d,g2g,m2m,r2r), function(f) f(test_angles)))
unitnames <- c("deg","grad","mil","rad")
colnames(normalised) <- sapply(unitnames, function(s) paste0(s, "_norm"))

d2x <- function(a, unit) switch(unit, "grad"=a*10/9, "mil"=a*160/9, "rad"=a*pi/180)
g2x <- function(a, unit) switch(unit, "deg"=a*9/10, "mil"=a*16, "rad"=a*pi/200)
m2x <- function(a, unit) switch(unit, "deg"=a*9/160, "grad"=a/16, "rad"=a*pi/3200)
r2x <- function(a, unit) switch(unit, "deg"=a*180/pi, "grad"=a*200/pi, "mil"=a*3200/pi)

deg_conv <- sapply(unitnames[-1], function(unit) d2x(d2d(test_angles), unit))
grad_conv <- sapply(unitnames[-2], function(unit) g2x(g2g(test_angles), unit))
mil_conv <- sapply(unitnames[-3], function(unit) m2x(m2m(test_angles), unit))
rad_conv <- sapply(unitnames[-4], function(unit) r2x(r2r(test_angles), unit))

conv_list <- list(deg_conv, grad_conv, mil_conv, rad_conv)
setNames(lapply(1:4, function(n) cbind(test_angles, normalised[n], conv_list[[n]])), unitnames)
