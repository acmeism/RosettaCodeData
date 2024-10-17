// version 1.1.3

val animals = listOf("fly", "spider", "bird", "cat","dog", "goat", "cow", "horse")

val phrases = listOf(
    "",
    "That wriggled and jiggled and tickled inside her",
    "How absurd to swallow a bird",
    "Fancy that to swallow a cat",
    "What a hog, to swallow a dog",
    "She just opened her throat and swallowed a goat",
    "I don't know how she swallowed a cow",
    "\n  ...She's dead of course"
)

fun sing() {
    for (i in 0..7) {
       println("There was an old lady who swallowed a ${animals[i]};")
       if (i > 0) println("${phrases[i]}!")
       if (i == 7) return
       println()
       if (i > 0) {
           for (j in i downTo 1) {
               print("  She swallowed the ${animals[j]} to catch the ${animals[j - 1]}")
               println(if (j < 3) ";" else ",")
               if (j == 2) println("  ${phrases[1]}!")
           }
       }
       println("  I don't know why she swallowed a fly - Perhaps she'll die!\n")
    }
}

fun main(args: Array<String>) {
    sing()
}
