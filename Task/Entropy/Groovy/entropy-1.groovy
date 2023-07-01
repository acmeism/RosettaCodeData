String.metaClass.getShannonEntrophy = {
    -delegate.inject([:]) { map, v -> map[v] = (map[v] ?: 0) + 1; map }.values().inject(0.0) { sum, v ->
        def p = (BigDecimal)v / delegate.size()
        sum + p * Math.log(p) / Math.log(2)
    }
}
