import complex, rationals, math, fenv, sugar

func isInteger[T: Complex | Rational | SomeNumber](x: T; tolerance = 0f64): bool =
  when T is Complex:
    x.im == 0 and x.re.isInteger
  elif T is Rational:
    x.dup(reduce).den == 1
  elif T is SomeFloat:
    ceil(x) - x <= tolerance
  elif T is SomeInteger:
    true

# Floats.
assert not NaN.isInteger
assert not INF.isInteger      # Indeed, "ceil(INF) - INF" is NaN.
assert not (-5e-2).isInteger
assert (-2.1e120).isInteger
assert 25.0.isInteger
assert not 24.999999.isInteger
assert 24.999999.isInteger(tolerance = 0.00001)
assert not (1f64 + epsilon(float64)).isInteger
assert not (1f32 - epsilon(float32)).isInteger
# Rationals.
assert not (5 // 3).isInteger
assert (9 // 3).isInteger
assert (-143 // 13).isInteger
# Unsigned integers.
assert 3u.isInteger
# Complex numbers.
assert not (1.0 + im 1.0).isInteger
assert (5.0 + im 0.0).isInteger
