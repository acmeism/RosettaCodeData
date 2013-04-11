# This code takes a ridiculously inefficient algorithm and rather futilely
# optimizes one part of it.  Permutations are computed lazily.

sorted_copy = (a) ->
  # This returns a sorted copy of an array by lazily generating
  # permutations of indexes and stopping when the indexes yield
  # a sorted array.
  indexes = [0...a.length]
  ans = find_matching_permutation indexes, (permuted_indexes) ->
    new_array = (a[i] for i in permuted_indexes)
    console.log permuted_indexes, new_array
    in_order(new_array)
  (a[i] for i in ans)

in_order = (a) ->
  # return true iff array a is in increasing order.
  return true if a.length <= 1
  for i in [0...a.length-1]
    return false if a[i] > a[i+1]
  true

get_factorials = (n) ->
  # return an array of the first n+1 factorials, starting with 0!
  ans = [1]
  f = 1
  for i in [1..n]
    f *= i
    ans.push f
  ans

permutation = (a, i, factorials) ->
  # Return the i-th permutation of an array by
  # using remainders of factorials to determine
  # elements.
  while a.length > 0
    f = factorials[a.length-1]
    n = Math.floor(i / f)
    i = i % f
    elem = a[n]
    a = a[0...n].concat(a[n+1...])
    elem
  # The above loop gets treated like
  # an array expression, so it returns
  # all the elements.

find_matching_permutation = (a, f_match) ->
  factorials = get_factorials(a.length)
  for i in [0...factorials[a.length]]
    permuted_array = permutation(a, i, factorials)
    if f_match permuted_array
      return permuted_array
  null


do ->
  a = ['c', 'b', 'a', 'd']
  console.log 'input:', a
  ans = sorted_copy a
  console.log 'DONE!'
  console.log 'sorted copy:', ans
