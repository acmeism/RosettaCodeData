id(x) = x -> x
zero() = x -> id(x)
add(m) = n -> (f -> (x -> n(f)(m(f)(x))))
mult(m) = n -> (f -> (x -> n(m(f))(x)))
exp(m) = n -> n(m)
succ(i::Int) = i + 1
succ(cn) = f -> (x -> f(cn(f)(x)))
church2int(cn) = cn(succ)(0)
int2church(n) = n < 0 ? throw("negative Church numeral") : (n == 0 ? zero() : succ(int2church(n - 1)))

function runtests()
    church3 = int2church(3)
    church4 = int2church(4)
    println("Church 3 + Church 4 = ", church2int(add(church3)(church4)))
    println("Church 3 * Church 4 = ", church2int(mult(church3)(church4)))
    println("Church 4 ^ Church 3 = ", church2int(exp(church4)(church3)))
    println("Church 3 ^ Church 4 = ", church2int(exp(church3)(church4)))
end

runtests()
