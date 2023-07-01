val graph = mapOf(
    "des_system_lib" to "std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee".split(" ").toSet(),
    "dw01" to "ieee dw01 dware gtech".split(" ").toSet(),
    "dw02" to "ieee dw02 dware".split(" ").toSet(),
    "dw03" to "std synopsys dware dw03 dw02 dw01 ieee gtech".split(" ").toSet(),
    "dw04" to "dw04 ieee dw01 dware gtech".split(" ").toSet(),
    "dw05" to "dw05 ieee dware".split(" ").toSet(),
    "dw06" to "dw06 ieee dware".split(" ").toSet(),
    "dw07" to "ieee dware".split(" ").toSet(),
    "dware" to "ieee dware".split(" ").toSet(),
    "gtech" to "ieee gtech".split(" ").toSet(),
    "ramlib" to "std ieee".split(" ").toSet(),
    "std_cell_lib" to "ieee std_cell_lib".split(" ").toSet(),
    "synopsys" to setOf()
)

fun toposort( graph: Map<String,Set<String>> ): List<List<String>> {
    var data = graph.map { (k,v) -> k to v.toMutableSet() }.toMap().toMutableMap()

    // ignore self dependancies
    data = data.map { (k,v) -> v.remove(k); k to v }.toMap().toMutableMap()

    val extraItemsInDeps = data.values.reduce { a,b -> a.union( b ).toMutableSet() } - data.keys.toSet()

    data.putAll( extraItemsInDeps.map { it to mutableSetOf<String>() }.toMap() )

    val res = mutableListOf<List<String>>()
    mainloop@ while( true ) {
        innerloop@ while( true ) {
            val ordered = data.filter{ (_,v) -> v.isEmpty() }.map { (k,_) -> k }
            if( ordered.isEmpty() )
                break@innerloop

            res.add( ordered )
            data = data.filter { (k,_) -> !ordered.contains(k) }.map { (k,v) -> v.removeAll(ordered); k to v }.toMap().toMutableMap()
        }

        if( data.isNotEmpty() )
            throw Exception( "A cyclic dependency exists amongst: ${data.toList().joinToString { "," }}" )
        else
            break@mainloop
    }

    return res
}


fun main( args: Array<String> ) {
    val result = toposort( graph )
    println( "sorted dependencies:[\n${result.joinToString( ",\n")}\n]" )
}
