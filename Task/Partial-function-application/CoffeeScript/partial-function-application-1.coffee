partial = (f, g) ->
  (s) -> f(g, s)

fs = (f, s) -> (f(a) for a in s)
f1 = (a) -> a * 2
f2 = (a) -> a * a
fsf1 = partial(fs, f1)
fsf2 = partial(fs, f2)

do ->
  for seq in [[0..3], [2,4,6,8]]
    console.log fsf1 seq
    console.log fsf2 seq
