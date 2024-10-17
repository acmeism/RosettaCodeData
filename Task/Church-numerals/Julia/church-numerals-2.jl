id = x -> x
always(f) = d -> f
struct Church # used for "infinite" Church type resolution
  unchurch::Function
end
(cn::Church)(ocn::Church) = cn.unchurch(ocn)
compose(cnl::Church) = cnr::Church -> Church(f -> cnl(cnr(f)))
(cn::Church)(fn::Function) = cn.unchurch(fn)
(cn::Church)(i::Int) = cn.unchurch(i)
zero = Church(always(Church(id)))
one = Church(id)
succ(cn::Church) = Church(f -> (x -> f(cn(f)(x))))
add(m::Church) = n::Church -> Church(f -> n(f) ∘ m(f))
mult(m::Church) = n::Church -> Church(f -> m(n(f)))
exp(m::Church) = n::Church -> Church(n(m))
iszero(n::Church) = n.unchurch(Church(always(zero)))(one)
pred(n::Church) = Church(f -> Church(x -> n(
    g -> (h -> h(g(f))))(Church(always(x)))(Church(id))))
subt(n::Church) = m::Church -> Church(f -> m(pred)(n)(f))
divr(n::Church) = d::Church ->
  Church(f -> ((v::Church -> v(Church(always(succ(divr(v)(d)))))(zero))(
                   subt(n)(d)))(f))
div(dvdnd::Church) = dvsr::Church -> divr(succ(dvdnd))(dvsr)
church2int(cn::Church) = cn(i -> i + 1)(0)
int2church(n) = n <= 0 ? zero : succ(int2church(n - 1))

function runtests()
    church3 = int2church(3)
    church4 = succ(church3)
    church11 = int2church(11)
    church12 = succ(church11)
    println("Church 3 + Church 4 = ", church2int(add(church3)(church4)))
    println("Church 3 * Church 4 = ", church2int(mult(church3)(church4)))
    println("Church 3 ^ Church 4 = ", church2int(exp(church3)(church4)))
    println("Church 4 ^ Church 3 = ", church2int(exp(church4)(church3)))
    println("isZero(Church 0) = ", church2int(iszero(zero)))
    println("isZero(Church 3) = ", church2int(iszero(church3)))
    println("pred(Church 4) = ", church2int(pred(church4)))
    println("pred(Church 0) = ", church2int(pred(zero)))
    println("Church 11 - Church 3 = ", church2int(subt(church11)(church3)))
    println("Church 11 / Church 3 = ", church2int(div(church11)(church3)))
    println("Church 12 / Church 3 = ", church2int(div(church12)(church3)))
end

runtests()
