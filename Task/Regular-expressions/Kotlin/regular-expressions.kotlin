// version 1.0.6

fun main(args: Array<String>) {
    val s1 = "I am the original string"
    val r1 = Regex("^.*string$")
    if (s1.matches(r1)) println("`$s1` matches `$r1`")
    val r2 = Regex("original")
    val s3 = "replacement"
    val s2 = s1.replace(r2, s3)
    if (s2 != s1) println("`$s2` replaces `$r2` with `$s3`")
}
