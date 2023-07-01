if !has("lambda")
    echoerr 'Lambda feature required'
    finish
endif
let Y = {f -> {x -> x(x)}({y -> f({... -> call(y(y), a:000)})})}
let Fac = {f -> {n -> n<2 ? 1 : n * f(n-1)}}

echo Y(Fac)(5)
echo map(range(10), 'Y(Fac)(v:val)')
