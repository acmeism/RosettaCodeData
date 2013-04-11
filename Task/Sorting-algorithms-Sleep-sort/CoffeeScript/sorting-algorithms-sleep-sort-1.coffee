after = (s, f) -> setTimeout f, s*1000

# Setting Computer Science back at least a century, maybe more,
# this algorithm sorts integers using a highly parallelized algorithm.
sleep_sort = (arr) ->
  for n in arr
    do (n) -> after n, -> console.log n

do ->
  input = (parseInt(arg) for arg in process.argv[2...])
  sleep_sort input
