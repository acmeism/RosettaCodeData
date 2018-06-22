use std::ops::Add;
struct Amb<'a> {
    list: Vec<Vec<&'a str>>,
}
fn main() {
    let amb = Amb {
        list: vec![
            vec!["the", "that", "a"],
            vec!["frog", "elephant", "thing"],
            vec!["walked", "treaded", "grows"],
            vec!["slowly", "quickly"],
        ],
    };
    match amb.do_amb(0, 0 as char) {
        Some(text) => println!("{}", text),
        None => println!("Nothing found"),
    }
}
impl<'a> Amb<'a> {
    fn do_amb(&self, level: usize, last_char: char) -> Option<String> {
        if self.list.is_empty() {
            panic!("No word list");
        }
        if self.list.len() <= level {
            return Some(String::new());
        }
        let mut res = String::new();
        let word_list = &self.list[level];
        for word in word_list {
            if word.chars().next().unwrap() == last_char || last_char == 0 as char {
                res = res.add(word).add(" ");
                let answ = self.do_amb(level + 1, word.chars().last().unwrap());
                match answ {
                    Some(x) => {
                        res = res.add(&x);
                        return Some(res);
                    }
                    None => res.clear(),
                }
            }
        }
        None
    }
}
