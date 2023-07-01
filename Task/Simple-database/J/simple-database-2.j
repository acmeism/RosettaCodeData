D='jconsole s dataflow'

$D add name expression algebraic  rank     valence example explanation
$D add insert 'f/ y' 'insert f within y' infinite dyad 'sum=: +/' 'continued_fraction=:+`%/'
$D add fork '(f g h)y' 'g(f(y),h(y))' infinite monad 'average=: +/ % #' 'sum divided by tally'
$D add hook '(f g)y' 'f(y,g(y))' infinite monad '(/: 2&{"1)table' 'sort by third column'
$D add hook 'x(f g)y' 'f(x,g(y))' infinite dyad 'display verb in s' 'a reflexive dyadic hook'
$D add fork 'x(f g h)y' 'g(f(x,y),h(x,y))' infinite dyad '2j1(+ * -)9 12' 'product of sum and difference'
$D add reflexive 'f~ y' 'f(y,y)' infinite monad '^~y' 'y raised to the power of y'
$D add passive 'x f~ y' 'f(y,x)' 'ranks of f' dyad '(%~ i.@:>:) 8x' '8 intervals from 0 to 1'
$D add atop 'f@g y' 'f(g(y))' 'rank of g' monad '*:@(+/)' 'square the sum'
$D add atop 'x f@g y' 'f(g(x,y))' 'rank of g' dyad '>@{.' '(lisp) open the car'
$D add 'many more!'
