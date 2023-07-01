require 'stats/base'

NB.*isUniformX v Tests (5%) whether y is uniformly distributed
NB. result is: boolean describing if distribution y is uniform
NB. y is: distribution to test
NB. x is: optionally specify number of categories possible
isUniformX=: verb define
  (#~. y) isUniformX y
:
  signif=. 0.95                    NB. set significance level
  expected=. (#y) % x              NB. number of items divided by the category count
  observed=. #/.~ y                NB. frequency count for each category
  X2=. +/ (*: observed - expected) % expected  NB. the test statistic
  degfreedom=. <: x                NB. degrees of freedom
  signif > degfreedom chisqcdf :: 1: X2
)
