def totalWeight = { list -> list.collect{ it.item.weight * it.count }.sum() }
def totalVolume = { list -> list.collect{ it.item.volume * it.count }.sum() }
def totalValue = { list -> list.collect{ it.item.value * it.count }.sum() }

def knapsackUnbounded = { possibleItems, BigDecimal weightMax, BigDecimal volumeMax ->
    def n = possibleItems.size()
    def wm = weightMax.unscaledValue()
    def vm = volumeMax.unscaledValue()
    def m = (0..n).collect{ i -> (0..wm).collect{ w -> (0..vm).collect{ v -> [] } } }
    (1..wm).each { w ->
        (1..vm).each { v ->
            (1..n).each { i ->
                def item = possibleItems[i-1]
                def wi = item.weight.unscaledValue()
                def vi = item.volume.unscaledValue()
                def bi = [w.intdiv(wi),v.intdiv(vi)].min()
                m[i][w][v] = (0..bi).collect{ count ->
                    m[i-1][w - wi * count][v - vi * count] + [[item:item, count:count]]
                }.max(totalValue).findAll{ it.count }
            }
        }
    }
    m[n][wm][vm]
}
