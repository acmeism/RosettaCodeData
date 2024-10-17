function showextremes()
  values = [0.0, -0.0, Inf, -Inf, NaN]
  println(1 ./ values)
end

showextremes()

@show Inf + 2.0
@show Inf + Inf
@show Inf - Inf
@show Inf * Inf
@show Inf / Inf
@show Inf * 0
@show 0 == -0
@show NaN == NaN
@show NaN === NaN
