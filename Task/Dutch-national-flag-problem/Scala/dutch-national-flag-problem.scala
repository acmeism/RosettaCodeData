object FlagColor extends Enumeration {
    type FlagColor = Value
    val Red, White, Blue = Value
}

val genBalls = (1 to 10).map(i => FlagColor(scala.util.Random.nextInt(FlagColor.maxId)))
val sortedBalls = genBalls.sorted
val sorted = if (genBalls == sortedBalls) "sorted" else "not sorted"

println(s"Generated balls (${genBalls mkString " "}) are $sorted.")
println(s"Sorted balls (${sortedBalls mkString " "}) are sorted.")
