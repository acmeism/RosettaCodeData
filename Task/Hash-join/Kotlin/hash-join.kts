data class A(val age: Int, val name: String)

data class B(val character: String, val nemesis: String)

data class C(val rowA: A, val rowB: B)

fun hashJoin(tableA: List<A>, tableB: List<B>): List<C> {
    val mm = tableB.groupBy { it.character }
    val tableC = mutableListOf<C>()
    for (a in tableA) {
        val value = mm[a.name] ?: continue
        for (b in value) tableC.add(C(a, b))
    }
    return tableC.toList()
}

fun main(args: Array<String>) {
    val tableA = listOf(
        A(27, "Jonah"),
        A(18, "Alan"),
        A(28, "Glory"),
        A(18, "Popeye"),
        A(28, "Alan")
    )
    val tableB = listOf(
        B("Jonah", "Whales"),
        B("Jonah", "Spiders"),
        B("Alan", "Ghosts"),
        B("Alan", "Zombies"),
        B("Glory", "Buffy")
    )
    val tableC = hashJoin(tableA, tableB)
    println("A.Age A.Name B.Character B.Nemesis")
    println("----- ------ ----------- ---------")
    for (c in tableC) {
        print("${c.rowA.age}    ${c.rowA.name.padEnd(6)} ")
        println("${c.rowB.character.padEnd(6)}      ${c.rowB.nemesis}")
    }
}
