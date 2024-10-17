use itertools::Itertools;

fn commatize(old_text: &str, start_index: usize, step: usize, sep: &str) -> String {
    let mut text = old_text.to_string();
    let len = text.len();
    let textchars = text.chars().collect_vec();
    for i in start_index..len {
        if "123456789".contains(textchars[i]) {
            for j in i + 1..=len {
                if j >= len || !"0123456789".contains(textchars[j]) { //start at end
                    if step <= j - i {
                        for k in (i..j - step).rev().step_by(step) {
                            text.insert_str(k + 1, sep);
                        }
                        break;
                    }
                }
            }
            break;
        }
    }
    return text;
}

fn main() {
    let tests = [
	("pi=3.14159265358979323846264338327950288419716939937510582097494459231", 6, 5, " "),
	("The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", 0, 3, ","),
	("\"-in Aus$+1411.8millions\"", 0, 3, ","),
	("===US$0017440 millions=== (in 2000 dollars)", 0, 3, ","),
	("123.e8000 is pretty big.", 0, 3, ","),
	("The land area of the earth is 57268900(29% of the surface) square miles.", 0, 3, ","),
	("Ain't no numbers in this here words, nohow, no way, Jose.", 0, 3, ","),
	("James was never known as 0000000007", 0, 3, ","),
	("Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.", 0, 3, ","),
	("   $-140000±100 millions.", 0, 3, ","),
	("6/9/1946 was a good year for some.", 0, 3, ","),];
    for t in tests {
        println!(
            "Before: {}\nAfter: {}\n",
            t.0,
            commatize(t.0, t.1, t.2, t.3)
        );
    }
}
