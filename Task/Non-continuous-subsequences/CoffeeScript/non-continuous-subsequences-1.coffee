is_contigous_binary = (n) ->
  # return true if binary representation of n is
  # of the form 1+0+
  # examples:
  #     0 true
  #     1 true
  #   100 true
  #   110 true
  #  1001 false
  #  1010 false

  # special case zero, or you'll get an infinite loop later
  return true if n == 0

  # first remove 0s from end
  while n % 2 == 0
    n = n / 2

  # next, take advantage of the fact that a continuous
  # run of 1s would be of the form 2^n - 1
  is_power_of_two(n + 1)

is_power_of_two = (m) ->
  while m % 2 == 0
    m = m / 2
  m == 1

seq_from_bitmap = (arr, n) ->
  # grabs elements from array according to a bitmap
  # e.g. if n == 13 (1101), and arr = ['a', 'b', 'c', 'd'],
  # then return ['a', 'c', 'd'] (flipping bits to 1011, so
  # that least significant bit comes first)
  i = 0
  new_arr = []
  while n > 0
    if n % 2 == 1
      new_arr.push arr[i]
      n -= 1
    n /= 2
    i += 1
  new_arr

non_contig_subsequences = (arr) ->
  # Return all subsqeuences from an array that have a "hole" in
  # them.  The order of the subsequences is not specified here.

  # This algorithm uses binary counting, so it is limited to
  # small lists, but large lists would be unwieldy regardless.
  bitmasks = [0...Math.pow(2, arr.length)]
  (seq_from_bitmap arr, n for n in bitmasks when !is_contigous_binary n)

arr = [1,2,3,4]
console.log non_contig_subsequences arr
for n in [1..10]
  arr = [1..n]
  num_solutions = non_contig_subsequences(arr).length
  console.log "for n=#{n} there are #{num_solutions} solutions"
