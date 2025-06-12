trait RosettaExt {
    fn split_duplicates(&self) -> SplitDuplicates;
}

impl RosettaExt for &str {
    fn split_duplicates(&self) -> SplitDuplicates {
        SplitDuplicates { string: self }
    }
}

struct SplitDuplicates<'a> {
    string: &'a str,
}

impl<'a> Iterator for SplitDuplicates<'a> {
    type Item = &'a str;

    fn next(&mut self) -> Option<Self::Item> {
        if self.string.is_empty() {
            None
        } else {
            // We want to keep track of the char boundaries when we split
            let mut chars = self.string.char_indices();
            let mut l = chars.next()?;

            for r in chars {
                // Compare characters; if they don't match, split
                if l.1 != r.1 {
                    let (ret, rem) = self.string.split_at(r.0);
                    self.string = rem;

                    return Some(ret);
                }
                l = r;
            }

            // No more characters to compare, return the remaining string slice
            let ret = self.string;

            // Exhaust string slice
            self.string = &self.string[self.string.len()..];

            Some(ret)
        }
    }
}

fn splitter(s: &str) -> String {
    s.split_duplicates().collect::<Vec<_>>().join(", ")
}

fn main() {
    let test_string = "g";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));

    let test_string = "";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));

    let test_string = "gHHH5YY++///\\";
    println!("input string: {}", test_string);
    println!("output string: {}", splitter(test_string));
}
