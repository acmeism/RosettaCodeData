val maxDepth = 4

val ackMMap  = scala.collection.mutable.Map[BigInt, BigInt]()
val ackNMaps = Array.fill(maxDepth + 1) { scala.collection.mutable.Map[BigInt, BigInt]() }

def ack(m: Int, n: BigInt): BigInt = {
    if ((m < 0) || (n < 0)) {
        throw new Exception("Negative parameters are not allowed: ack(%s, %s)".format(m, n))
    }
    if (m > maxDepth) {
        throw new Exception("First parameter is greater as %s: ack(%s, %s)".format(maxDepth, m, n))
    }

    val newM        = m - 1
    val newN        = n - 1

    if (m == 0) {
        n + 1
    } else if (n == 0) {
        ackMMap.getOrElseUpdate(newM, ack(newM, 1))
    } else {
        val createStep   = 125
        val index        = m
        val mapCurrent   = ackNMaps(index)
        val mapPrevious  = ackNMaps(index - 1)
        val maxRecursion = 2 * createStep
        val nrOfElements : BigInt = if (mapCurrent.isEmpty) 0 else mapCurrent.max._1

        if ((nrOfElements + maxRecursion) < n) {
            for (i <- nrOfElements + createStep to n by createStep) {
                mapCurrent.getOrElseUpdate(i, ack(m, i))
            }
        }
        mapCurrent.getOrElseUpdate(n, {
            val ackVal = mapCurrent.getOrElseUpdate(newN, ack(m, newN))

            mapPrevious.getOrElseUpdate(ackVal, ack(newM, ackVal))
        })
    }
}
