Idotr=: |.@[ (#@[ - I.) ]             NB. reverses order of limits to obtain intervals closed on left, open on right (>= y <)
binnedData=: adverb define
  bidx=. i.@>:@# x                    NB. indicies of bins
  x (Idotr (u@}./.)&(bidx&,) ]) y     NB. apply u to data in each bin after dropping first value
)

require 'format/printf'
printBinCounts=: dyad define
  counts =. y
  '%2d   in [ -∞, %3d)' printf ({. counts) , {. x
  '%2d   in [%3d, %3d)' printf (}.}: counts) ,. 2 ]\ x
  '%2d   in [%3d, ∞]' printf ({: counts) , {: x
)
