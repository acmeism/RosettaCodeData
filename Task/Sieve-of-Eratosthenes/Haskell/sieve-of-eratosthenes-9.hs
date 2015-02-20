zipWith (flip (!!)) [0..]
  . scanl1 minus . scanl1 (zipWith(+)) $ repeat [2..]
