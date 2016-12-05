import bigints, math, sequtils, times

iterator nodups_hamming(): BigInt =
  var
    m = newSeq[BigInt](1) # give it two values so doubling size works
    h = newSeq[BigInt](1) # reasonably size
    x5 = initBigInt 5
    mrg = initBigInt 3
    x53 = initBigInt 9 # already advanced one step
    x532 = initBigInt 2
    ih, jm, i, j = 0

  yield initBigInt 1 # trivial case of 1
  while true:
    let cph = h.len # move in-place to avoid allocation
    if i >= cph div 2: # move in-place to avoid allocation
      var s = i; var d = 0
      while s < ih: shallowCopy(h[d], h[s]); s += 1; d += 1
      ih -= i; i = 0
    if i >= cph div 2: moveMem(h[0].unsafeAddr,
                               h[i].unsafeAddr,
                               (ih - i) * h[i].sizeof); ih -= i; i = 0
    if ih >= cph: h.setLen(2 * cph)
    if x532 < mrg: h[ih] = x532; x532 = h[i] * 2; i += 1
    else:
      h[ih] = mrg
      let cpm = m.len
      if j >= cpm div 2: # move in-place to avoid allocation
        var s = j; var d = 0
        while s < jm: shallowCopy(m[d], m[s]); s += 1; d += 1
        jm -= j; j = 0
      if jm >= cpm: m.setLen(2 * cpm)
      if x53 < x5: mrg = x53; x53 = m[j] * 3; j += 1
      else: mrg = x5; x5 = x5 * 5
      m[jm] = mrg
      jm += 1
    ih += 1

    yield h[ih - 1]
