require 'plot'
start=: 0 0,: 1 0
step=: ],{: +"1 (0 _1,: 1 0) +/ .*~ |.@}: -"1 {:
plot <"1 |: step^:13 start
