fn text_between(str string, start string, end string) string {
    if str == "" || start == "" || end == "" {
        return str
    }
    mut s := 0
    if start != "start" {
        s = str.index(start) or {-1}
    }
    if s == -1 {
        return ""
    }
    mut si := 0
    if start != "start" {
        si = s + start.len
    }
    mut e := str.len
    if end != "end" {
        e = str[si..].index(end) or {-1}
        if e == -1 {
            return str[si..]
        }
        e += si
    }
    return str[si..e]
}

fn main() {
    texts := [
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "</div><div style=\"chinese\">你好嗎</div>",
        "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
        "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
        "The quick brown fox jumps over the lazy other fox",
        "One fish two fish red fish blue fish",
        "FooBarBazFooBuxQuux",
    ]
    starts:= [
        "Hello ", "start", "Hello ", "<div style=\"chinese\">",
        "<text>", "<table>", "quick ", "fish ", "Foo",
    ]
    ends := [
        " world", " world", "end", "</div>", "<table>",
        "</table>", " fox", " red", "Foo",
    ]
    for i, text in texts {
        println("Text: \"$text\"")
        println("Start delimiter: \"${starts[i]}\"")
        println("End delimiter: \"${ends[i]}\"")
        b := text_between(text, starts[i], ends[i])
        println("Output: \"$b\"\n")
    }
}
