F:{[g]     / graph
 n: #g     / number of vertices
 v::&n     / visited?
 L::!0     / dfs order
 V: {[g;x] $[v x;;[v[x]:1;o[g]'g x;L::x,L]];}[g]
 V'!n      / Visit
 G: @[n#,!0;g;,;!n] / transposed graph
 c::n#-1   / assigned components
 A: {[G;x;y] $[-1=c x;[c[x]:y;G[x]o[G]'y];]}[G]'
 A'/2#,L   / Assign
 .=c}
