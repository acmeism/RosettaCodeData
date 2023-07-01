USING: kernel math.matrices.extras prettyprint ;

{ { 1 2 } { 3 4 } }
{ { 0 5 } { 6 7 } }
{ { 0 1 0 } { 1 1 1 } { 0 1 0 } }
{ { 1 1 1 1 } { 1 0 0 1 } { 1 1 1 1 } }
[ kronecker-product . ] 2bi@
