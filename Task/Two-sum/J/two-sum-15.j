zeroLowerTri=: * [: </~ i.@#
getIdx=: 4 $. $.
twosum_alt=: getIdx@zeroLowerTri@(= +/~)
