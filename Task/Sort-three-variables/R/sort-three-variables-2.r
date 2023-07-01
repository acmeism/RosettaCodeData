x <- 'lions, tigers, and'
y <- 'bears, oh my!'
z <- '(from the "Wizard of OZ")'

c("x", "y", "z") %<<-% sort(c(x, y, z))

x
## [1] "(from the \"Wizard of OZ\")"
y
## [1] "bears, oh my!"
z
## [1] "lions, tigers, and"


x <- 77444
y <-   -12
z <-     0

c("x", "y", "z") %<<-% sort(c(x, y, z))

x
## [1] -12
y
## [1] 0
z
## [1] 77444
