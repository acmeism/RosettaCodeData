fn wrap(text string, line_width int) string {
    mut wrapped := ''
    words := text.fields()
    if words.len == 0 {
        return wrapped
    }
    wrapped = words[0]
    mut space_left := line_width - wrapped.len
    for word in words[1..] {
        if word.len+1 > space_left {
            wrapped += "\n" + word
            space_left = line_width - word.len
        } else {
            wrapped += " " + word
            space_left -= 1 + word.len
        }
    }
    return wrapped
}

const frog = "
In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
that the sun itself, which has seen so much, was astonished whenever
it shone in her face.  Close by the king's castle lay a great dark
forest, and under an old lime-tree in the forest was a well, and when
the day was very warm, the king's child went out into the forest and
sat down by the side of the cool fountain, and when she was bored she
took a golden ball, and threw it up on high and caught it, and this
ball was her favorite plaything."

fn main() {
    println("wrapped at 80:")
    println(wrap(frog, 80))
    println("wrapped at 72:")
    println(wrap(frog, 72))
}
