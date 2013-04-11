f = (a, b) ->
  p "and", a & b
  p "or", a | b
  p "xor", a ^ b
  p "not", ~a
  p "<<", a << b
  p ">>", a >> b
  # no rotation shifts that I know of

p = (label, n) -> console.log label, n

f(10,2)
