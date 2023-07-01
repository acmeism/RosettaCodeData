def totalWeight = { list -> list*.weight.sum() }
def totalValue = { list -> list*.value.sum() }

def knapsack01bf = { possibleItems ->
    possibleItems.subsequences().findAll{ ss ->
        def w = totalWeight(ss)
        350 < w && w < 401
    }.max(totalValue)
}
