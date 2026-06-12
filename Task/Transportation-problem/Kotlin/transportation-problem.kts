// version 1.1.51

import java.io.File
import java.util.Scanner
import java.util.LinkedList

class Transport(val filename: String) {

    private val supply: IntArray
    private val demand: IntArray
    private val costs : Array<DoubleArray>
    private val matrix: Array<Array<Shipment>>

    class Shipment(
        var quantity: Double,
        val costPerUnit: Double,
        val r: Int,
        val c: Int
    )

    companion object {
        private val ZERO = Shipment(0.0, 0.0, -1, -1) // to avoid nullable Shipments
    }

    init {
        val sc = Scanner(File(filename))
        try {
            val numSources = sc.nextInt()
            val numDestinations = sc.nextInt()
            val src = MutableList(numSources) { sc.nextInt() }
            val dst = MutableList(numDestinations) { sc.nextInt() }

            // fix imbalance
            val totalSrc = src.sum()
            val totalDst = dst.sum()
            if (totalSrc > totalDst)
                dst.add(totalSrc -totalDst)
            else if (totalDst > totalSrc)
                src.add(totalDst -totalSrc)
            supply = src.toIntArray()
            demand = dst.toIntArray()

            costs  = Array(supply.size) { DoubleArray(demand.size) }
            matrix = Array(supply.size) { Array(demand.size) { ZERO } }
            for (i in 0 until numSources) {
                for (j in 0 until numDestinations) costs[i][j] = sc.nextDouble()
            }
        }
        finally {
            sc.close()
        }
    }

    fun northWestCornerRule() {
        var northwest = 0
        for (r in 0 until supply.size) {
            for (c in northwest until demand.size) {
                val quantity = minOf(supply[r], demand[c]).toDouble()
                if (quantity > 0.0) {
                    matrix[r][c] = Shipment(quantity, costs[r][c], r, c)
                    supply[r] -= quantity.toInt()
                    demand[c] -= quantity.toInt()
                    if (supply[r] == 0) {
                        northwest = c
                        break
                    }
                }
            }
        }
    }

    fun steppingStone() {
        var maxReduction = 0.0
        var move: Array<Shipment>? = null
        var leaving = ZERO
        fixDegenerateCase()

        for (r in 0 until supply.size) {
            for (c in 0 until demand.size) {
                if (matrix[r][c] != ZERO) continue
                val trial = Shipment(0.0, costs[r][c], r, c)
                val path = getClosedPath(trial)
                var reduction = 0.0
                var lowestQuantity = Int.MAX_VALUE.toDouble()
                var leavingCandidate = ZERO
                var plus = true
                for (s in path) {
                    if (plus) {
                        reduction += s.costPerUnit
                    }
                    else {
                        reduction -= s.costPerUnit
                        if (s.quantity < lowestQuantity) {
                            leavingCandidate = s
                            lowestQuantity = s.quantity
                        }
                    }
                    plus = !plus
                }
                if (reduction < maxReduction) {
                    move = path
                    leaving = leavingCandidate
                    maxReduction = reduction
                }
            }
        }

        if (move != null) {
            val q = leaving.quantity
            var plus = true
            for (s in move) {
                s.quantity += if (plus) q else -q
                matrix[s.r][s.c] = if (s.quantity == 0.0) ZERO else s
                plus = !plus
            }
            steppingStone()
        }
    }

    private fun matrixToList() =
        LinkedList<Shipment>(matrix.flatten().filter { it != ZERO } )

    private fun getClosedPath(s: Shipment): Array<Shipment> {
        val path = matrixToList()
        path.addFirst(s)

        // remove (and keep removing) elements that do not have a
        // vertical AND horizontal neighbor
        while (path.removeIf {
            val nbrs = getNeighbors(it, path)
            nbrs[0] == ZERO || nbrs[1] == ZERO
        }) ; // empty statement

        // place the remaining elements in the correct plus-minus order
        val stones = Array<Shipment>(path.size) { ZERO }
        var prev = s
        for (i in 0 until stones.size) {
            stones[i] = prev
            prev = getNeighbors(prev, path)[i % 2]
        }
        return stones
    }

    private fun getNeighbors(s: Shipment, lst: LinkedList<Shipment>): Array<Shipment> {
        val nbrs = Array<Shipment>(2) { ZERO }
        for (o in lst) {
            if (o != s) {
                if (o.r == s.r && nbrs[0] == ZERO)
                    nbrs[0] = o
                else if (o.c == s.c && nbrs[1] == ZERO)
                    nbrs[1] = o
                if (nbrs[0] != ZERO && nbrs[1] != ZERO) break
            }
        }
        return nbrs
    }

    private fun fixDegenerateCase() {
        val eps = Double.MIN_VALUE
        if (supply.size + demand.size - 1 != matrixToList().size) {
            for (r in 0 until supply.size) {
                for (c in 0 until demand.size) {
                    if (matrix[r][c] == ZERO) {
                        val dummy = Shipment(eps, costs[r][c], r, c)
                        if (getClosedPath(dummy).size == 0) {
                            matrix[r][c] = dummy
                            return
                        }
                    }
                }
            }
        }
    }

    fun printResult() {
        val text = File(filename).readText()
        println("$filename\n\n$text")
        println("Optimal solution $filename\n")
        var totalCosts = 0.0

        for (r in 0 until supply.size) {
            for (c in 0 until demand.size) {
                val s = matrix[r][c]
                if (s != ZERO && s.r == r && s.c == c) {
                    print(" %3s ".format(s.quantity.toInt()))
                    totalCosts += s.quantity * s.costPerUnit
                }
                else print("  -  ")
            }
            println()
        }
        println("\nTotal costs: $totalCosts\n")
    }
}

fun main(args: Array<String>) {
    val filenames = arrayOf("input1.txt", "input2.txt", "input3.txt")
    for (filename in filenames) {
        with (Transport(filename)) {
            northWestCornerRule()
            steppingStone()
            printResult()
        }
    }
}
