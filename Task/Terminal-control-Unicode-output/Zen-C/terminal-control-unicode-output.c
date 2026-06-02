import "std/env.zc"

fn supports_unicode() -> bool {
    let lang = Env::get("LANG").unwrap();
    let res = strstr(lang, "utf-8") || strstr(lang, "UTF-8");
    return (bool)res;
}

fn main() {
    if supports_unicode() {
        println "Unicode is supported on this terminal and U+25B3 is : \u25b3";
    } else {
        println "Unicode is not supported on this terminal.";
    }
}
