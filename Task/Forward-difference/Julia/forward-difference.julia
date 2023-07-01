ndiff(A::Array, n::Integer) = n < 1 ? A : diff(ndiff(A, n-1))

s = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73]
println.(collect(ndiff(s, i) for i in 0:9))
