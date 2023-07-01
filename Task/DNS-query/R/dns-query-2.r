library(Rcpp)
sourceCpp("dns.cpp")
getNameInfo("www.kame.net")
## [1] "203.178.141.194"
## [2] "2001:200:dff:fff1:216:3eff:feb1:44d7"
