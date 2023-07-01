var greedyWordWrap = Fn.new { |text, lineWidth|
    var words = text.split(" ")
    var sb = words[0]
    var spaceLeft = lineWidth - words[0].count
    for (word in words.skip(1)) {
        var len = word.count
        if (len + 1 > spaceLeft) {
            sb = sb + "\n" + word
            spaceLeft = lineWidth - len
        } else {
            sb = sb + " " + word
            spaceLeft = spaceLeft - len - 1
        }
    }
    return sb
}

var text =
    "In olden times when wishing still helped one, there lived a king " +
    "whose daughters were all beautiful, but the youngest was so beautiful " +
    "that the sun itself, which has seen so much, was astonished whenever " +
    "it shone in her face.  Close by the king's castle lay a great dark " +
    "forest, and under an old lime tree in the forest was a well, and when " +
    "the day was very warm, the king's child went out into the forest and " +
    "sat down by the side of the cool fountain, and when she was bored she " +
    "took a golden ball, and threw it up on high and caught it, and this " +
    "ball was her favorite plaything."

System.print("Greedy algorithm - wrapped at 72:")
System.print(greedyWordWrap.call(text, 72))
System.print("\nGreedy algorithm - wrapped at 80:")
System.print(greedyWordWrap.call(text, 80))
