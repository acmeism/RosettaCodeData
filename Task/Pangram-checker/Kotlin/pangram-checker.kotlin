// version 1.0.6

fun isPangram(s: String): Boolean {
    if (s.length < 26) return false
    val t = s.toLowerCase()
    for (c in 'a' .. 'z')
        if (c !in t) return false
    return true
}

fun main(args: Array<String>) {
   val candidates = arrayOf(
       "The quick brown fox jumps over the lazy dog",
       "New job: fix Mr. Gluck's hazy TV, PDQ!",
       "A very bad quack might jinx zippy fowls",
       "A very mad quack might jinx zippy fowls"   // no 'b' now!
   )
   for (candidate in candidates)
       println("'$candidate' is ${if (isPangram(candidate)) "a" else "not a"} pangram")
}
