require 'prime'

p ar = pr = Prime.take(10)
4.times{p ar = ar.product(pr).map{|(a,b)| a*b}.uniq.sort.take(10)}
