case class Verse(animal: String, remark: String, die: Boolean = false, always: Boolean = false)

val verses = List(
  Verse("horse", "She’s dead, of course!", die = true),
  Verse("donkey", "It was rather wonky. To swallow a donkey."),
  Verse("cow", "I don’t know how. To swallow a cow."),
  Verse("goat", "She just opened her throat. To swallow a goat."),
  Verse("pig", "Her mouth was so big. To swallow a pig."),
  Verse("dog", "What a hog. To swallow a dog."),
  Verse("cat", "Fancy that. To swallow a cat."),
  Verse("bird", "Quite absurd. To swallow a bird."),
  Verse("spider", "That wriggled and jiggled and tickled inside her."),
  Verse("fly", "I don’t know why she swallowed the fly.", always = true)
)

for (i <- 1 to verses.size; verse = verses takeRight i; starting = verse.head) {
  println(s"There was an old lady who swallowed a ${starting.animal},")
  println(starting.remark)
  if (!starting.die) {
    for (List(it, next) <- verse.sliding(2,1)) {
      println(s"She swallowed the ${it.animal} to catch the ${next.animal},")
      if (next.always) println(next.remark)
    }
    println("Perhaps she’ll die!")
    println
  }
}
