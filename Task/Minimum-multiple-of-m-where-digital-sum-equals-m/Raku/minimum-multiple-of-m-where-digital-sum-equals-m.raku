sub min-mult-dsum ($n) { (1..∞).first: (* × $n).comb.sum == $n }

say .fmt("%2d: ") ~ .&min-mult-dsum for flat 1..40, 41..70;
