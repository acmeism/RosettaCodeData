Set solutions = []
items.eachPermutation { itemList ->
    def start = System.currentTimeMillis()
    def packingList = knapsackUnbounded(itemList, 25.0, 0.250)
    def elapsed = System.currentTimeMillis() - start

    println "\n  Item Order: ${itemList.collect{ it.name.split()[0] }}"
    println "Elapsed Time: ${elapsed/1000.0} s"

    solutions << (packingList as Set)
}

solutions.each { packingList ->
    println "\nTotal Weight: ${totalWeight(packingList)}"
    println "Total Volume: ${totalVolume(packingList)}"
    println " Total Value: ${totalValue(packingList)}"
    packingList.each {
        printf ('  item: %-22s  count:%2d  weight:%4.1f  Volume:%5.3f\n',
                it.item.name, it.count, it.item.weight * it.count, it.item.volume * it.count)
    }
}
