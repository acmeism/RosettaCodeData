// version 1.0.6

class Oid(val id: String): Comparable<Oid> {
    override fun compareTo(other: Oid): Int {
        val splits1 = this.id.split('.')
        val splits2 = other.id.split('.')
        val minSize = if (splits1.size < splits2.size) splits1.size else splits2.size
        for (i in 0 until minSize) {
            if (splits1[i].toInt() < splits2[i].toInt()) return -1
            else if (splits1[i].toInt() > splits2[i].toInt()) return 1
        }
        return splits1.size.compareTo(splits2.size)
    }

    override fun toString() = id
}

fun main(args: Array<String>) {
    val oids = arrayOf(
        Oid("1.3.6.1.4.1.11.2.17.19.3.4.0.10"),
        Oid("1.3.6.1.4.1.11.2.17.5.2.0.79"),
        Oid("1.3.6.1.4.1.11.2.17.19.3.4.0.4"),
        Oid("1.3.6.1.4.1.11150.3.4.0.1"),
        Oid("1.3.6.1.4.1.11.2.17.19.3.4.0.1"),
        Oid("1.3.6.1.4.1.11150.3.4.0")
    )
    println(oids.sorted().joinToString("\n"))
}
