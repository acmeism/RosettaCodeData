"First 10 superfactorials:",
 (range(0;10) | sf),

"\nFirst 10 hyperfactorials:",
 (range(0; 10) | H),

"\nFirst 10 alternating factorials:",
 (range(0;10) | af),

"\n\nFirst 5 exponential factorials:",
 (range(0;5) | ef),

"\nThe number of digits in 5$ is \(5 | ef | tostring | length)",

"\nReverse factorials:",
 ( 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119 | "\(rf) <- rf(\(.))")
