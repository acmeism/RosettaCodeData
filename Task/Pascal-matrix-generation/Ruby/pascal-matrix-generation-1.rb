#Upper, lower, and symetric Pascal Matrix - Nigel Galloway: May 3rd., 21015
require 'pp'

ng = (g = 0..4).collect{[]}
g.each{|i| g.each{|j| ng[i][j] = i==0 ? 1 : j<i ? 0 : ng[i-1][j-1]+ng[i][j-1]}}
pp ng; puts
g.each{|i| g.each{|j| ng[i][j] = j==0 ? 1 : i<j ? 0 : ng[i-1][j-1]+ng[i-1][j]}}
pp ng; puts
g.each{|i| g.each{|j| ng[i][j] = (i==0 or j==0) ? 1 : ng[i-1][j  ]+ng[i][j-1]}}
pp ng
