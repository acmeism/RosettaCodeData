fun main() {
    val s1 = "abracadabra"
    val s2 = "abra"
    println("$s1 begins with $s2: ${s1.startsWith(s2)}")
    println("$s1 ends with $s2: ${s1.endsWith(s2)}")
    val b = s2 in s1
    if (b) {
        print("$s1 contains $s2 at these indices: ")
        // can use indexOf to get first index or lastIndexOf to get last index
        // to get ALL indices, use a for loop or Regex
        println(
            s2.toRegex(RegexOption.LITERAL).findAll(s1).joinToString { it.range.start.toString() }
        )
    }
    else println("$s1 does not contain $2.")
}
