def ccI = { BigInteger tot, List<BigInteger> coins ->
    List<BigInteger> ways = [0g] * (tot+1)
    ways[0] = 1g
    coins.each { BigInteger coin ->
        (coin..tot).each { j ->
            ways[j] += ways[j-coin]
        }
    }
    ways[tot]
}
