import "std/string.zc"

fn look_and_say(s: string) -> String {
    let res = String::from("");
    let digit = s[0];
    let count = 1;
    for i in 1..strlen(s) {
        if s[i] == digit {
            count++;
        } else {
            res.append_c("{count}{digit:c}");
            digit = s[i];
            count = 1;
        }
    }
    res.append_c("{count}{digit:c}");
    return res;
}

fn main() {
    let s: char[100];
    strcpy(s, "1");
    for i in 1..=15 {
        println "{s}";
        let las = look_and_say(s);
        strcpy(s, las.c_str());
    }
}
