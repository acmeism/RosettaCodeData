ratios = hofcon / seq_along(hofcon)

message("Maxima:")
print(sapply(1 : 20, function(pwr)
   max(ratios[2^(pwr - 1) : 2^pwr])))

message("Prize-winning point:")
print(max(which(ratios >= .55)))
