def largestInt = { c -> c.sort { v2, v1 -> "$v1$v2" <=> "$v2$v1" }.join('') as BigInteger }
