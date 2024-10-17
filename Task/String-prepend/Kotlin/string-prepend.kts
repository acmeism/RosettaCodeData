// version 1.0.6

fun main(args: Array<String>) {
    var s = "Obama"
    s = "Barack " + s
    println(s)

    // It's also possible to use this standard library function
    // though this is not what it's really intended for
    var t = "Trump"
    t = t.prependIndent("Donald ")
    println(t)
}
