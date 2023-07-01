#[ This version uses ASCII for case-sensitive matching. For Unicode you may want to match in UTF-8
   bytes instead of creating a 0x10FFFF-sized table.
]#

import std/[algorithm, sequtils, strutils]

const AlphabetSize = 256

func reversed(s: string): string =
  ## Return the reverse of an ASCII string.
  for i in countdown(s.high, 0):
    result.add s[i]

proc alphabetIndex(c: char): int =
  ## Return the index of the given ASCII character.
  result = ord(c)
  assert result in 0..<ALPHABET_SIZE

proc matchLength(s: string; idx1, idx2: int): int =
  ## Return the length of the match of the substrings of "s" beginning at "idx1" and "idx2".
  if idx1 == idx2: return s.len - idx1
  var idx1 = idx1
  var idx2 = idx2
  while idx1 < s.len and idx2 < s.len and s[idx1] == s[idx2]:
    inc result
    inc idx1
    inc idx2

proc fundamentalPreprocess(s: string): seq[int] =
  ## Return "z", the Fundamental Preprocessing of "s".

  # "z[i]" is the length of the substring beginning at "i" which is also a prefix of "s".
  # This preprocessing is done in O(n) time, where n is the length of "s".
  if s.len == 0: return
  if s.len == 1: return @[1]
  result = repeat(0, s.len)
  result[0] = s.len
  result[1] = s.matchLength(0, 1)
  for i in 2..result[1]:
    result[i] = result[1] - i + 1
  # Defines lower and upper limits of z-box.
  var l, r = 0
  for i in (2 + result[1])..s.high:
    if i <= r:    # "i" falls within existing z-box.
      let k = i - l
      let b = result[k]
      let a = r - i + 1
      if b < a:   # "b" ends within existing z-box.
        result[i] = b
      else:  # "b" ends at or after the end of the z-box.
        # We need to do an explicit match to the right of the z-box.
        result[i] = a + s.matchLength(a, r + 1)
        l = i
        r = i + result[i] - 1
    else:  # "i" does not reside within existing z-box.
      result[i] = s.matchLength(0, i)
      if result[i] > 0:
        l = i
        r = i + result[i] - 1

proc badCharacterTable(s: string): seq[seq[int]] =
  ## Generates "R" for "s", which is an array indexed by the position of some character "c"
  ## in the ASCII table.

  # At that index in "R" is an array of length |s|+1, specifying for each index "i" in "s"
  # (plus the index after "s") the next location of character "c" encountered when traversing
  # "S" from right to left starting at "i". This is used for a constant-time lookup for the bad
  # character rule in the Boyer-Moore string search algorithm, although it has a much larger
  # size than non-constant-time solutions.
  if s.len == 0: return newSeqWith(AlphabetSize, newSeq[int]())
  result = repeat(@[-1], AlphabetSize)
  var alpha = repeat(-1, AlphabetSize)
  for i, c in s:
    alpha[alphabetIndex(c)] = i
    for j, a in alpha:
      result[j].add a

proc goodSuffixTable(s: string): seq[int] =
  ## Generates "L" for "s", an array used in the implementation of the strong good suffix rule.

  # "L[i] = k", the largest position in S such that "s[i:]" (the suffix of "s" starting at "i")
  # matches a suffix of "s[:k]" (a substring in "s" ending at "k"). Used in Boyer-Moore, "L"
  # gives an amount to shift "P" relative to "T" such that no instances of "P" in "T" are skipped
  # and a suffix of "P[:L[i]]" matches the substring of "T" matched by a suffix of "P" in the
  # previous match attempt.
  # Specifically, if the mismatch took place at position "i-1" in "P", the shift magnitude is
  # given by the formula "len(P) - L[i]". In the case that "L[i] = -1", the full shift table
  # is used. Since only proper suffixes matter, "L[0] = -1".
  result =repeat(-1, s.len)
  var n = fundamentalPreprocess(reversed(s))
  n.reverse()
  for j in 0..(s.len - 2):
    let i = s.len - n[j]
    if i != s.len:
      result[i] = j

proc fullShiftTable(s: string): seq[int] =
  ## Generates "F" for "s", an array used in a special case of the good suffix rule in the
  ## Boyer-Moore string search algorithm.

  # "F[i]" is the length of the longest suffix of "s[i:]" that is also a prefix of "s". In
  # the cases it is used, the shift magnitude of the pattern "P" relative to the text "T" is
  # "len(P) - F[i]" for a mismatch occurring at "i-1".
  result = repeat(0, s.len)
  let z = fundamentalPreprocess(s)
  var longest = 0
  for i, zv in reversed(z):
    if zv == i + 1:
      longest = max(zv, longest)
      result[^(i + 1)] = longest

proc stringSearch(p, t: string): seq[int] =
  ## Implementation of the Boyer-Moore string search algorithm.

  # This finds all occurrences of "p" in "t", and incorporates numerous ways of preprocessing
  # the pattern to determine the optimal amount to shift the string and skip comparisons.
  # In practice it runs in O(m) (and even sublinear) time, where "m" is the length of "t".
  # This implementation performs a case-sensitive search on ASCII characters. "p" must be
  # ASCII as well.

  if p.len == 0 or t.len == 0 or t.len < p.len: return

  # Preprocessing
  let r = badCharacterTable(p)
  let l = goodSuffixTable(p)
  let f = fullShiftTable(p)

  var k = p.len - 1   # Represents alignment of end of "p" relative to "t".
  var prevk = -1      # Represents alignment in previous phase (Galil's rule).
  while k < t.len:
    var i = p.len - 1  # Character to compare in "p".
    var h = k          # Character to compare in "t".
    while i >= 0 and h > prevk and p[i] == t[h]:  # Matches starting from end of "p".
      dec i
      dec h
    if i == -1 or h == prevk:  # Match has been found (Galil's rule).
      result.add k - p.len + 1
      inc k, (if p.len > 1: p.len - f[1] else: 1)
    else:  # No match: shift by max of bad character and good suffix rules.
      let charShift = i - r[alphabetIndex(t[h])][i]
      let suffixShift = if i + 1 == p.len:    # Mismatch happened on first attempt.
                          1
                        elif l[i + 1] == -1:  # Matched suffix does not appear anywhere in "p".
                          p.len - f[i + 1]
                        else:                 # Matched suffix appears in "p".
                          p.len - 1 - l[i + 1]
      let shift = max(charShift, suffixShift)
      if shift >= i + 1: prevk = k  # Galil's rule
      inc k, shift

const
  Text1 = "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesley" &
          "DKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassembly" &
          "languagestoillustratetheconceptsandalgorithmsastheyarepresented"
  Text2 = "Nearby farms grew a half acre of alfalfa on the dairy's behalf, " &
          "with bales of all that alfalfa exchanged for milk."
  (Pat1, Pat2, Pat3) = ("put", "and", "alfalfa")

echo "Found '", Pat1, "' at: ", Pat1.stringSearch(Text1).join(", ")
echo "Found '", Pat2, "' at: ", Pat2.stringSearch(Text1).join(", ")
echo "Found '", Pat3, "' at: ", Pat3.stringSearch(Text2).join(", ")
