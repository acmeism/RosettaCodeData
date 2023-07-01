sub count-substring($big, $little) { +$big.comb: / :r $little / }

say count-substring("the three truths", "th"); # 3
say count-substring("ababababab", "abab");     # 2

say count-substring(123123123, 12);            # 3
