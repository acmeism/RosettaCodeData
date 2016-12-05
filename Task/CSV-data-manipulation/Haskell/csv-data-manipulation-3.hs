sampleSum = sample <||> (mkRow ["SUM"] <==> mkColumn sums)
  where sums = map (show . sum) (read <$$> drop 1 (values sample))
