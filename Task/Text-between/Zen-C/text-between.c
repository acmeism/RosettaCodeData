import "std/string.zc"

fn text_between(str: string, start: string, end: string) -> String {
    if strlen(start) == 0 || strlen(end) == 0 {
        eprintln "Start and end must both be non-empty strings.";
    }
    if strlen(str) == 0 { return String::new(""); }
    let s: int;
    let t: int;
    if strcmp(start, "start") == 0 {
        s = 0;
        t = 0;
    } else {
        let u = strstr(str, start);
        if u {
            s = u - str;
            t = s + strlen(start);
        } else {
            return String::new("");
        }
    }
    let e: int;
    if strcmp(end, "end") == 0 {
        e = strlen(str);
    } else {
        let u = strstr(str + t, end);
        if u {
            e = u - str;
        } else {
            let ss = String::from(str);
            return ss.substring(t, ss.length() - t);
        }
    }
    let ss = String::from(str);
    return ss.substring(t, e - t);
}

fn main() {
    let texts = [
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "Hello Rosetta Code world",
        "</div><div style=\"chinese\">你好嗎</div>",
        "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
        "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
        "The quick brown fox jumps over the lazy other fox",
        "One fish two fish red fish blue fish",
        "FooBarBazFooBuxQuux"
    ];

    let starts = [
        "Hello ", "start", "Hello ", "<div style=\"chinese\">",
        "<text>", "<table>", "quick ", "fish ", "Foo"
    ];

    let ends = [
        " world", " world", "end", "</div>", "<table>",
        "</table>", " fox", " red", "Foo"
    ];

    for i, text in texts {
        println "Text   : \"{text}\"";
        println "Start  : \"{starts[i]}\"";
        println "End    : \"{ends[i]}\"";
        let b = text_between(text, starts[i], ends[i]);
        println "Result : \"{b}\"\n";
    }
}
