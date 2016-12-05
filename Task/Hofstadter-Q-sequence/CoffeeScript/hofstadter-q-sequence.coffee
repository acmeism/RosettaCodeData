hofstadterQ = do ->
  memo = [ 1 ,1, 1]
  Q = (n) ->
    result = memo[n]
    if typeof result != 'number'
      result = memo[n] = Q(n - Q(n - 1)) + Q(n - Q(n - 2))
    result

# some results:
console.log 'Q(' + i + ') = ' + hofstadterQ(i) for i in [1..10]
console.log 'Q(1000) = ' + hofstadterQ(1000)
