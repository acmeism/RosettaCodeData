mus:{ / values of mu(i) for i below x
 (~~!x) {                  / initial value: 0 1 1 1 1 ...
  y[z  *1+!(-z  )!x-1]*:-1 / flip sign
  y[z*z*1+!(-z*z)!x-1]:0   / set squares to zero
  y}[x]/ `pri x}           / for each prime below x
(μ:):{mus[1+0|/,//x]x}
`0:"The first 100 values of the μ function:"
`0:,/'-3$$μ 10 10#1+!100
