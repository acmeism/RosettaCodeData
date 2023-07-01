import static java.math.RoundingMode.*

def knapsackCont = { list, maxWeight = 15.0 ->
    list.sort{ it.weight / it.value }
    def remainder = maxWeight
    List sack = []
    for (item in list) {
        if (item.weight < remainder) {
            sack << [name: item.name, weight: item.weight,
                        value: (item.value as BigDecimal).setScale(2, HALF_UP)]
        } else {
            sack << [name: item.name, weight: remainder,
                        value: (item.value * remainder / item.weight).setScale(2, HALF_UP)]
            break
        }
        remainder -= item.weight
    }
    sack
}
