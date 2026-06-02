import "std/string.zc"

fn greedy_word_wrap(text: string, line_width: const int) -> String {
    let text2 = String::from(text);
    let text3 = text2.replace("\n", "");
    let words = text3.split(' ');
    let sb = String::new("");
    let len0 = words[0].length();
    sb.append_c(words[0].c_str());
    let space_left = line_width - len0;
    for i in 1..words.length() {
        let len = words[i].length();
        if len + 1 > space_left {
            sb.append_c("\n");
            sb.append_c(words[i].c_str());
            space_left = line_width - len;
        } else {
            sb.append_c(" ");
            sb.append_c(words[i].c_str());
            space_left -= len + 1;
        }
    }
    for word in words { word.free(); }
    return sb;
}

fn main() {
    let text: const string = """
In olden times when wishing still helped one, there lived a king
whose daughters were all beautiful, but the youngest was so beautiful
that the sun itself, which has seen so much, was astonished whenever
it shone in her face.  Close by the king's castle lay a great dark
forest, and under an old lime tree in the forest was a well, and when
the day was very warm, the king's child went out into the forest and
sat down by the side of the cool fountain, and when she was bored she
took a golden ball, and threw it up on high and caught it, and this
ball was her favorite plaything."""

    println "Greedy algorithm - wrapped at 72:";
    println "{greedy_word_wrap(text, 72)}";
    println "\nGreedy algorithm - wrapped at 80:";
    println "{greedy_word_wrap(text, 80)}";
}
