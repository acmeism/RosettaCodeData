require 'trig'
haversin=: 0.5 * 1 - cos
Rearth=: 6372.8
haversineDist=: Rearth * haversin^:_1@((1 , *&(cos@{.)) +/ .* [: haversin -)&rfd
