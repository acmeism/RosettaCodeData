data class Person(val name: String) {
    val preferences = mutableListOf<Person>()
    var matchedTo: Person? = null

    fun trySwap(p: Person) {
        if (prefers(p)) {
            matchedTo?.matchedTo = null
            matchedTo = p
            p.matchedTo = this
        }
    }

    fun prefers(p: Person) = when (matchedTo) {
        null -> true
        else -> preferences.indexOf(p) < preferences.indexOf(matchedTo!!)
    }

    fun showMatch() = "$name <=> ${matchedTo?.name}"
}

fun match(males: Collection<Person>) {
    while (males.find { it.matchedTo == null }?.also { match(it) } != null) {
    }
}

fun match(male: Person) {
    while (male.matchedTo == null) {
        male.preferences.removeAt(0).trySwap(male)
    }
}

fun isStableMatch(males: Collection<Person>, females: Collection<Person>): Boolean {
    return males.all { isStableMatch(it, females) }
}

fun isStableMatch(male: Person, females: Collection<Person>): Boolean {

    val likesBetter = females.filter { !male.preferences.contains(it) }
    val stable = !likesBetter.any { it.prefers(male) }

    if (!stable) {
        println("#### Unstable pair: ${male.showMatch()}")
    }
    return stable
}


fun main(args: Array<String>) {
    val inMales = mapOf(
            "abe" to mutableListOf("abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"),
            "bob" to mutableListOf("cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"),
            "col" to mutableListOf("hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"),
            "dan" to mutableListOf("ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"),
            "ed" to mutableListOf("jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"),
            "fred" to mutableListOf("bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"),
            "gav" to mutableListOf("gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"),
            "hal" to mutableListOf("abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"),
            "ian" to mutableListOf("hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"),
            "jon" to mutableListOf("abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"))

    val inFemales = mapOf(
            "abi" to listOf("bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"),
            "bea" to listOf("bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"),
            "cath" to listOf("fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"),
            "dee" to listOf("fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"),
            "eve" to listOf("jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"),
            "fay" to listOf("bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"),
            "gay" to listOf("jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"),
            "hope" to listOf("gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"),
            "ivy" to listOf("ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"),
            "jan" to listOf("ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"))


    fun buildPrefs(person: Person, stringPrefs: List<String>, population: List<Person>) {
        person.preferences.addAll(
                stringPrefs.map { name -> population.single { it.name == name } }
        )
    }

    val males = inMales.keys.map { Person(it) }
    val females = inFemales.keys.map { Person(it) }

    males.forEach { buildPrefs(it, inMales[it.name]!!, females) }
    females.forEach { buildPrefs(it, inFemales[it.name]!!, males) }


    match(males)
    males.forEach { println(it.showMatch()) }
    println("#### match is stable: ${isStableMatch(males, females)}")


    fun swapMatch(male1: Person, male2: Person) {
        val female1 = male1.matchedTo!!
        val female2 = male2.matchedTo!!

        male1.matchedTo = female2
        male2.matchedTo = female1

        female1.matchedTo = male2
        female2.matchedTo = male1
    }

    swapMatch(males.single { it.name == "fred" }, males.single { it.name == "jon" })
    males.forEach { println(it.showMatch()) }
    println("#### match is stable: ${isStableMatch(males, females)}")
}
