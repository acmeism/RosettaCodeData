sub count-substring($big,$little) { +$big.comb: ~$little }

say count-substring("the three truths","th"); # 3
say count-substring("ababababab","abab");     # 4

say count-substring(123123123,12);            # 3
