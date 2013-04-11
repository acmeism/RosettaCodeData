missing_permutation = (arr) ->
  # Find the missing permutation in an array of N! - 1 permutations.

  # We won't validate every precondition, but we do have some basic
  # guards.
  if arr.length == 0
    throw Error "Need more data"
  if arr.length == 1
      return [arr[0][1] + arr[0][0]]

  # Now we know that for each position in the string, elements should appear
  # an even number of times (N-1 >= 2).  We can use a set to detect the element appearing
  # an odd number of times.  Detect odd occurrences by toggling admission/expulsion
  # to and from the set for each value encountered.  At the end of each pass one element
  # will remain in the set.
  result = ''
  for pos in [0...arr[0].length]
      set = {}
      for permutation in arr
          c = permutation[pos]
          if set[c]
            delete set[c]
          else
            set[c] = true
      for c of set
        result += c
        break
  result

given = '''ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
  CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'''

arr = (s for s in given.replace('\n', ' ').split ' ' when s != '')

console.log missing_permutation(arr)
