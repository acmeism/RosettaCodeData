animals = [
        ("fly", "I don't know why she swallowed a fly, perhaps she'll die."),
        ("spider", "It wiggled and jiggled and tickled inside her."),
        ("bird", "How absurd, to swallow a bird."),
        ("cat", "Imagine that, she swallowed a cat."),
        ("dog", "What a hog, to swallow a dog."),
        ("goat", "She just opened her throat and swallowed a goat."),
        ("cow", "I don't know how she swallowed a cow."),
        ("horse", "She's dead, of course.")]

for i, (animal, lyric) in enumerate(animals):
    print "There was an old lady who swallowed a {}.\n{}".format(animal, lyric)

    if animal == "horse": break

    for (predator, _), (prey, _) in zip(animals[i:0:-1], animals[i-1::-1]):
        print "\tShe swallowed the {} to catch the {}".format(predator, prey)

    if animal != "fly": print animals[0][1]  # fly lyric
    print  # new line
