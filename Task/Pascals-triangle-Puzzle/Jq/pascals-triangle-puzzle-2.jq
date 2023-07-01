include "rc-cramers-rule";
def solve(top; mid; a; b):
  cramer(
     [ [7, 7],
       [2,  1]];
     [top - 4*(a+b), mid-2*a]);

solve(151; 40; 11; 4)
