horner2(coefs, x) = foldr((u, v) -> u + x * v, coefs, init=zero(promote_type(typeof(x),eltype(coefs))))

@show horner2([-19, 7, -4, 6], 3)
