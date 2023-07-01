def knapsack01dp = { possibleItems ->
    def n = possibleItems.size()
    def m = (0..n).collect{ i -> (0..400).collect{ w -> []} }
    (1..400).each { w ->
        (1..n).each { i ->
            def wi = possibleItems[i-1].weight
            m[i][w] = wi > w ? m[i-1][w] : ([m[i-1][w], m[i-1][w-wi] + [possibleItems[i-1]]].max(totalValue))
        }
    }
    m[n][400]
}
