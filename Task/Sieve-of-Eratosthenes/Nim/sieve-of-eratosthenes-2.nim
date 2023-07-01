iterator isoe_upto(top: uint): uint =
  let topndx = int((top - 3) div 2)
  let sqrtndx = (int(sqrt float64(top)) - 3) div 2
  var cmpsts = newSeq[uint32](topndx div 32 + 1)
  for i in 0 .. sqrtndx: # cull composites for primes
    if (cmpsts[i shr 5] and (1u32 shl (i and 31))) == 0:
      let p = i + i + 3
      for j in countup((p * p - 3) div 2, topndx, p):
        cmpsts[j shr 5] = cmpsts[j shr 5] or (1u32 shl (j and 31))
  yield 2 # separate culling above and iteration here
  for i in 0 .. topndx:
    if (cmpsts[i shr 5] and (1u32 shl (i and 31))) == 0:
      yield uint(i + i + 3)
