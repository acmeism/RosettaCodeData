F:{[g]             /graph
 n:#g              /number of vertices
 G:@[n#,!0;g;,;!n] /transposed graph
 V:{[g;L;x]$[^L?x;(1_(x,L)o[g]/g x),x;L]}[g]
 L:|V/[!0;!#g]     /Visit
 A:{[G;c;u;r]$[0>c u;o[G]/[@[c;u;:;r];G u;r];c]}[G]
 .=A/[n#-1;L;L]}   /Assign
