   DataSet=: rnorm01 1e5
   (mean , stddev) DataSet
0.000781667 1.00154
   require 'plot'
   plot (5 %~ i: 25) ([;histogram) DataSet
