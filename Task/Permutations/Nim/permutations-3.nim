import intsets
from math import fac
block:
  # test all permutations of length from 0 to 9
  for l in 0..9:

    # prepare data
    var xs = newSeq[int](l)
    for i in 0..<l: xs[i] = i
    var s = initIntSet()

    for cs in inplacePermutations(xs):

      # each permutation must be of length l
      assert len(cs) == l

      # each permutation must contain digits from 0 to l-1 exactly once
      var ds = newSeq[bool](l)
      for c in cs:
        assert not ds[c]
        ds[c] = true

      # generate a unique number for each permutation
      var h = 0
      for e in cs:
        h = l * h + e
      assert not s.contains(h)
      s.incl(h)

    # check exactly l! unique number of permutations
    assert len(s) == fac(l)
