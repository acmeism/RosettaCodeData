def missing_permutation(arr):
  "Find the missing permutation in an array of N! - 1 permutations."

  # We won't validate every precondition, but we do have some basic
  # guards.
  if len(arr) == 0: raise Exception("Need more data")
  if len(arr) == 1:
      return [arr[0][1] + arr[0][0]]

  # Now we know that for each position in the string, elements should appear
  # an even number of times (N-1 >= 2).  We can use a set to detect the element appearing
  # an odd number of times.  Detect odd occurrences by toggling admission/expulsion
  # to and from the set for each value encountered.  At the end of each pass one element
  # will remain in the set.
  missing_permutation = ''
  for pos in range(len(arr[0])):
      s = set()
      for permutation in arr:
          c = permutation[pos]
          if c in s:
            s.remove(c)
          else:
            s.add(c)
      missing_permutation += list(s)[0]
  return missing_permutation

given = '''ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
           CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB'''.split()

print missing_permutation(given)
