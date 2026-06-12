import kotlin.math.hypot
import kotlin.math.sqrt
import kotlin.random.Random

data class Pair(val x: Double, val y: Double)
data class Point(val pair: Pair, val id: Int)
data class Edge(val u: Int, val v: Int, val weight: Double) {
    override fun toString(): String {
        return "($u, $v, %.2f)".format(weight)
    }
}

data class Result(val path: List<Int>, val length: Double)

class MainKt {
    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            val data = listOf(
                Pair(1380.0, 939.0), Pair(2848.0, 96.0), Pair(3510.0, 1671.0), Pair(457.0, 334.0), Pair(3888.0, 666.0),
                Pair(984.0, 965.0), Pair(2721.0, 1482.0), Pair(1286.0, 525.0), Pair(2716.0, 1432.0), Pair(738.0, 1325.0),
                Pair(1251.0, 1832.0), Pair(2728.0, 1698.0), Pair(3815.0, 169.0), Pair(3683.0, 1533.0), Pair(1247.0, 1945.0),
                Pair(123.0, 862.0), Pair(1234.0, 1946.0), Pair(252.0, 1240.0), Pair(611.0, 673.0), Pair(2576.0, 1676.0),
                Pair(928.0, 1700.0), Pair(53.0, 857.0), Pair(1807.0, 1711.0), Pair(274.0, 1420.0), Pair(2574.0, 946.0),
                Pair(178.0, 24.0), Pair(2678.0, 1825.0), Pair(1795.0, 962.0), Pair(3384.0, 1498.0), Pair(3520.0, 1079.0),
                Pair(1256.0, 61.0), Pair(1424.0, 1728.0), Pair(3913.0, 192.0), Pair(3085.0, 1528.0), Pair(2573.0, 1969.0),
                Pair(463.0, 1670.0), Pair(3875.0, 598.0), Pair(298.0, 1513.0), Pair(3479.0, 821.0), Pair(2542.0, 236.0),
                Pair(3955.0, 1743.0), Pair(1323.0, 280.0), Pair(3447.0, 1830.0), Pair(2936.0, 337.0), Pair(1621.0, 1830.0),
                Pair(3373.0, 1646.0), Pair(1393.0, 1368.0), Pair(3874.0, 1318.0), Pair(938.0, 955.0), Pair(3022.0, 474.0),
                Pair(2482.0, 1183.0), Pair(3854.0, 923.0), Pair(376.0, 825.0), Pair(2519.0, 135.0), Pair(2945.0, 1622.0),
                Pair(953.0, 268.0), Pair(2628.0, 1479.0), Pair(2097.0, 981.0), Pair(890.0, 1846.0), Pair(2139.0, 1806.0),
                Pair(2421.0, 1007.0), Pair(2290.0, 1810.0), Pair(1115.0, 1052.0), Pair(2588.0, 302.0), Pair(327.0, 265.0),
                Pair(241.0, 341.0), Pair(1917.0, 687.0), Pair(2991.0, 792.0), Pair(2573.0, 599.0), Pair(19.0, 674.0),
                Pair(3911.0, 1673.0), Pair(872.0, 1559.0), Pair(2863.0, 558.0), Pair(929.0, 1766.0), Pair(839.0, 620.0),
                Pair(3893.0, 102.0), Pair(2178.0, 1619.0), Pair(3822.0, 899.0), Pair(378.0, 1048.0), Pair(1178.0, 100.0),
                Pair(2599.0, 901.0), Pair(3416.0, 143.0), Pair(2961.0, 1605.0), Pair(611.0, 1384.0), Pair(3113.0, 885.0),
                Pair(2597.0, 1830.0), Pair(2586.0, 1286.0), Pair(161.0, 906.0), Pair(1429.0, 134.0), Pair(742.0, 1025.0),
                Pair(1625.0, 1651.0), Pair(1187.0, 706.0), Pair(1787.0, 1009.0), Pair(22.0, 987.0), Pair(3640.0, 43.0),
                Pair(3756.0, 882.0), Pair(776.0, 392.0), Pair(1724.0, 1642.0), Pair(198.0, 1810.0), Pair(3950.0, 1558.0)
            )

            val points = data.mapIndexed { index, pair -> Point(pair, index) }
            christofidesPath(points)
        }

        fun christofidesPath(points: List<Point>): Result {
            if (points.isEmpty()) {
                return Result(emptyList(), 0.0)
            }
            if (points.size == 1) {
                return Result(listOf(points.first().id), 0.0)
            }

            val graph = Graph(points)
            graph.display()
            val minimumSpanningTree = graph.minimumSpanningTree()
            println("Minimum spanning tree: $minimumSpanningTree\n")
            val oddVertices = graph.oddVertices(minimumSpanningTree)
            println("Odd vertices in minimum spanning tree: $oddVertices\n")
            val minimumWeightMatching = graph.minimumWeightMatching(minimumSpanningTree, oddVertices)
            println("Minimum weight matching: $minimumWeightMatching\n")

            val eulerianCircuit = graph.eulerianCircuit(minimumWeightMatching)
            println("Eulerian circuit: $eulerianCircuit\n")

            if (eulerianCircuit.isEmpty()) {
                System.err.println("Error: Christofides path could not be found.")
                return Result(emptyList(), -1.0)
            }

            val result = graph.hamiltonianCircuit(eulerianCircuit)
            println("Result path: ${result.path}\n")
            println("Length of the result path: %.2f".format(result.length))

            return result
        }
    }

    class Graph(private val points: List<Point>) {
        private val pointCount: Int = points.size
        private val distanceLists: List<MutableList<Double>> = List(pointCount) { MutableList(pointCount) { 0.0 } }

        init {
            val distance = { one: Point, two: Point -> hypot(one.pair.x - two.pair.x, one.pair.y - two.pair.y) }

            for (i in 0 until pointCount) {
                for (j in i + 1 until pointCount) {
                    val dist = distance(points[i], points[j])
                    distanceLists[i][j] = dist
                    distanceLists[j][i] = dist
                }
            }
        }

        fun minimumSpanningTree(): List<Edge> {
            val edges = mutableListOf<Edge>()
            if (pointCount == 0) {
                return edges
            }

            for (i in 0 until pointCount) {
                for (j in i + 1 until pointCount) {
                    edges.add(Edge(i, j, distanceLists[i][j]))
                }
            }

            edges.sortBy { it.weight }
            val minimumSpanningTree = mutableListOf<Edge>()
            val unionFind = UnionFind(pointCount)
            var edgeCount = 0

            for (edge in edges) {
                if (unionFind.unite(edge.u, edge.v)) {
                    minimumSpanningTree.add(edge)
                    edgeCount++
                    if (edgeCount == pointCount - 1) {
                        break
                    }
                }
            }
            return minimumSpanningTree
        }

        fun oddVertices(minimumSpanningTree: List<Edge>): List<Int> {
            val degrees = MutableList(pointCount) { 0 }
            minimumSpanningTree.forEach { edge ->
                degrees[edge.u]++
                degrees[edge.v]++
            }

            return degrees.mapIndexedNotNull { index, degree -> if (degree % 2 == 1) index else null }
        }

        fun minimumWeightMatching(minimumSpanningTree: List<Edge>, oddVertices: List<Int>): List<Edge> {
            val minimumWeightMatching = mutableListOf<Edge>()
            if (oddVertices.isEmpty()) {
                return minimumWeightMatching
            }

            minimumWeightMatching.addAll(minimumSpanningTree)
            val currentOdd = oddVertices.toMutableList()
            currentOdd.shuffle()

            val visited = mutableSetOf<Int>()
            for (i in currentOdd.indices) {
                if (visited.contains(i)) {
                    continue
                }

                val v = currentOdd[i]
                var minimumDistance = Int.MAX_VALUE.toDouble()
                var closestUIndex: Int? = null

                for (j in i + 1 until currentOdd.size) {
                    if (!visited.contains(j)) {
                        val u = currentOdd[j]
                        if (distanceLists[v][u] < minimumDistance) {
                            minimumDistance = distanceLists[v][u]
                            closestUIndex = j
                        }
                    }
                }

                if (closestUIndex != null) {
                    val j = closestUIndex
                    val u = currentOdd[j]
                    minimumWeightMatching.add(Edge(v, u, minimumDistance))
                    visited.add(i)
                    visited.add(j)
                } else {
                    throw AssertionError("Could not match an odd vertex in minimum weight matching: $v")
                }
            }

            return minimumWeightMatching
        }

        fun eulerianCircuit(minimumWeightMatching: List<Edge>): List<Int> {
            val circuit = mutableListOf<Int>()
            if (minimumWeightMatching.isEmpty()) {
                return circuit
            }

            data class Twin(val halfEdge: Int, val index: Int)

            val adjacencyLists = List(pointCount) { mutableListOf<Twin>() }

            minimumWeightMatching.forEachIndexed { index, edge ->
                adjacencyLists[edge.u].add(Twin(edge.v, index))
                adjacencyLists[edge.v].add(Twin(edge.u, index))
            }

            val edgesUsed = mutableSetOf<Int>()
            val stack = mutableListOf<Int>()
            var currentVertex = minimumWeightMatching.first().u
            stack.add(currentVertex)

            while (stack.isNotEmpty()) {
                currentVertex = stack.last()
                var foundEdge = false

                while (adjacencyLists[currentVertex].isNotEmpty()) {
                    val twin = adjacencyLists[currentVertex].removeAt(adjacencyLists[currentVertex].size - 1)
                    if (!edgesUsed.contains(twin.index)) {
                        edgesUsed.add(twin.index)
                        stack.add(twin.halfEdge)
                        foundEdge = true
                        break
                    }
                }

                if (!foundEdge) {
                    circuit.add(stack.removeAt(stack.size - 1))
                }
            }

            circuit.reverse()
            return circuit
        }

        fun hamiltonianCircuit(eulerianCircuit: List<Int>): Result {
            val christofidesPath = mutableListOf<Int>()
            var length = 0.0
            val visited = mutableSetOf<Int>()

            var current = eulerianCircuit.first()
            christofidesPath.add(current)
            visited.add(current)

            for (vertex in eulerianCircuit) {
                if (!visited.contains(vertex)) {
                    christofidesPath.add(vertex)
                    visited.add(vertex)
                    length += distanceLists[current][vertex]
                    current = vertex
                }
            }

            length += distanceLists[current][christofidesPath.first()]
            christofidesPath.add(christofidesPath.first())
            return Result(christofidesPath, length)
        }

        fun display() {
            println("Graph: {")
            for (u in 0 until pointCount) {
                print("${u.toString().padStart(3)}: {")
                for (v in 0 until pointCount) {
                    if (u != v) {
                        if (!(u == 0 && v == 1) && v > 0) {
                            print(", ")
                        }
                        print("${v}: ${"%.2f".format(distanceLists[u][v])}")
                    }
                }
                println("}" + if (u == pointCount - 1) "" else ",")
            }
            println("}\n")
        }

        private class UnionFind(number: Int) {
            private val parents: MutableList<Int> = MutableList(number) { it }
            private val ranks: MutableList<Int> = MutableList(number) { 0 }

            fun find(n: Int): Int {
                if (parents[n] == n) {
                    return n
                }

                parents[n] = find(parents[n])
                return parents[n]
            }

            fun unite(i: Int, j: Int): Boolean {
                val rootI = find(i)
                val rootJ = find(j)

                if (rootI != rootJ) {
                    when {
                        ranks[rootI] < ranks[rootJ] -> parents[rootI] = rootJ
                        ranks[rootI] > ranks[rootJ] -> parents[rootJ] = rootI
                        else -> {
                            parents[rootJ] = rootI
                            ranks[rootI]++
                        }
                    }
                    return true
                }
                return false
            }
        }
    }
}

