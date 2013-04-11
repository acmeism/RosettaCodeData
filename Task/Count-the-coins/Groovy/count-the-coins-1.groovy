def ccR
ccR = { BigInteger tot, List<BigInteger> coins ->
    BigInteger n = coins.size()
    switch ([tot:tot, coins:coins]) {
        case { it.tot == 0 } :
            return 1g
        case { it.tot < 0 || coins == [] } :
            return 0g
        default:
            return ccR(tot, coins[1..<n]) +
                ccR(tot - coins[0], coins)
    }
}
