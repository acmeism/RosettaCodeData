def totalWeight = { list -> list.collect{ it.item.weight * it.count }.sum() }
def totalValue = { list -> list.collect{ it.item.value * it.count }.sum() }

def knapsackBounded = { possibleItems ->
    def n = possibleItems.size()
    def m = (0..n).collect{ i -> (0..400).collect{ w -> []} }
    (1..400).each { w ->
        (1..n).each { i ->
            def item = possibleItems[i-1]
            def wi = item.weight, pi = item.pieces
            def bi = [w.intdiv(wi),pi].min()
            m[i][w] = (0..bi).collect{ count ->
                m[i-1][w - wi * count] + [[item:item, count:count]]
            }.max(totalValue).findAll{ it.count }
        }
    }
    m[n][400]
}
