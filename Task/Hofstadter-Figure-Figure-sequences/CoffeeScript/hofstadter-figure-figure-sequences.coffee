R = [ null, 1 ]
S = [ null, 2 ]

extend_sequences = (n) ->
  current = Math.max(R[R.length - 1], S[S.length - 1])
  i = undefined
  while R.length <= n or S.length <= n
    i = Math.min(R.length, S.length) - 1
    current += 1
    if current == R[i] + S[i]
      R.push current
    else
      S.push current

ff = (X, n) ->
    extend_sequences n
    X[n]

console.log 'R(' + i + ') = ' + ff(R, i) for i in [1..10]
int_array = ([1..40].map (i) -> ff(R, i)).concat [1..960].map (i) -> ff(S, i)
int_array.sort (a, b) -> a - b

for i in [1..1000]
  if int_array[i - 1] != i
    throw 'Something\'s wrong!'
console.log '1000 integer check ok.'
