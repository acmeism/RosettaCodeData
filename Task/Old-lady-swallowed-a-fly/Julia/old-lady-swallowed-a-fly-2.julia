animals = [
    ("fly", "I don't know why she swallowed a fly, perhaps she'll die."),
    ("spider", "It wiggled and jiggled and tickled inside her."),
    ("bird", "How absurd, to swallow a bird."),
    ("cat", "Imagine that, she swallowed a cat."),
    ("dog", "What a hog, to swallow a dog."),
    ("goat", "She just opened her throat and swallowed a goat."),
    ("cow", "I don't know how she swallowed a cow."),
    ("horse", "She's dead, of course.")]

for (i, (animal, lyric)) in enumerate(animals)
    println("There was an old lady who swallowed a $animal.\n$lyric")

    if animal == "horse" break end

    for ((predator, _), (prey, _)) in zip(animals[i:-1:1], animals[i-1:-1:1])
        println("\tShe swallowed the $predator to catch the $prey")
    end

    if animal != "fly" println(animals[1][2]) end  # fly lyric
    println()  # new line
end
