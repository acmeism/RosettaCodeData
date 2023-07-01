const (
    name = 0
    lyric = 1
    animals = [
            ["fly", "I don't know why she swallowed a fly. Perhaps she'll die."],
            ["spider", "That wiggled and jiggled and tickled inside her."],
            ["bird", "How absurd, to swallow a bird."],
            ["cat", "Imagine that, she swallowed a cat."],
            ["dog", "What a hog, to swallow a dog."],
            ["goat", "She just opened her throat and swallowed that goat."],
            ["cow", "I don't know how she swallowed that cow."],
            ["horse", "She's dead, of course."],
        ]
)

fn main() {
    for i, animal in animals {
        println("There was an old lady who swallowed a ${animal[name]},")
        if i > 0 {
            println(animal[lyric])
        }
        // Swallowing the last animal signals her death, cutting the
        //  lyrics short.
        if i+1 == animals.len {
            break
        }
        for j := i; j > 0; j-- {
            println("She swallowed the ${animals[j][name]} to catch the ${animals[j-1][name]},")
        }
        println("${animals[0][lyric]}\n")
    }
}
