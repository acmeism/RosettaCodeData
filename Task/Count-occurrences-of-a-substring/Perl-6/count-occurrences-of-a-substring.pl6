sub count-substring($big,$little) { +$big.comb: /$little/ }

say count-substring("the three truths","th");
say count-substring("ababababab","abab");
