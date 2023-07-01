import strutils

proc missingPermutation(arr: openArray[string]): string =
  result = ""
  if arr.len == 0: return
  if arr.len == 1: return arr[0][1] & arr[0][0]

  for pos in 0 ..< arr[0].len:
    var s: set[char] = {}
    for permutation in arr:
      let c = permutation[pos]
      if c in s: s.excl c
      else:      s.incl c
    for c in s: result.add c

const given = """ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB DABC BCAD CADB CDBA
  CBAD ABDC ADBC BDCA DCBA BACD BADC BDAC CBDA DBCA DCAB""".splitWhiteSpace()

echo missingPermutation(given)
