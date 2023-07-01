#to install hilbercurve library, biocmanager needs to be installed first
install.packages("BiocManager")
BiocManager::install("HilbertCurve")
#loading library and setting seed for random numbers
library(HilbertCurve)
library(circlize)
set.seed(123)

#4th order peano curve is generated
for(i in 1:512) {
  peano = HilbertCurve(1, 512, level = 4, reference = TRUE, arrow = FALSE)
  hc_points(peano, x1 = i, np = NULL, pch = 16, size = unit(3, "mm"))
}
