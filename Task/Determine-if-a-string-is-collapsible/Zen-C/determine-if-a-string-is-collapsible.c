import "std/string.zc"

fn collapse(s: string) {
    let ss = String::new(s);
    let c = ss.runes();
    let le = (int)c.length();
    println "original : length = {le:2d}, string = «««{s}»»»";
    if le >= 2 {
        for let i = le - 2; i >= 0; --i {
            if c[i] == c[i + 1] { c.remove(i); }
        }
        let cl = (int)c.length();
        let cs = String::from_runes_vec(c);
        println "collapsed: length = {cl:2d}, string = «««{cs}»»»\n";
    } else {
        println "collapsed: length = {le:2d}, string = «««{s}»»»\n";
    }
}

fn main() {
    let strings = [
        "",
        "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
        "..1111111111111111111111111111111111111111111111111111111111111117777888",
        "I never give 'em hell, I just tell the truth, and they think it's hell. ",
        "                                                   ---  Harry S Truman  ",
        "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
        "headmistressship",
        "aardvark",
        "😍😀🙌💃😍😍😍🙌"
    ];
    for s in strings { collapse(s); }
}
