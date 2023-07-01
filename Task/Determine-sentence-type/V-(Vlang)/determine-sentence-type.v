fn sentence_type(s string) string {
    if s.len == 0 {
        return ""
    }
    mut types := []string{}
    for c in s.split('') {
        if c == '?' {
            types << "Q"
        } else if c == '!' {
            types << "E"
        } else if c == '.' {
            types << "S"
        }
    }
    if s[s.len-1..s.len].index_any('?!.') == -1 {
        types << "N"
    }
    return types.join("|")
}

fn main() {
    s := "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
    println(sentence_type(s))
}
