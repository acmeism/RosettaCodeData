rebol []  random/seed now  g: [style t box red [
  if not find [0x108 108x0 0x-108 -108x0] face/offset - e/offset [exit]
  x: face/offset face/offset: e/offset e/offset: x] across
] x: random repeat i 15 [append x:[] i]  repeat i 15 [
  repend g ['t mold x/:i random white] if find [4 8 12] i [append g 'return]
] append g [e: box]  view layout g
