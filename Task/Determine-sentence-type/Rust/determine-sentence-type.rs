#[derive(Debug)]
enum SentenceType {
    Neutral,
    Exclamation,
    Question,
    Serious
}

struct SentenceIter<'a> {
    rest: &'a str
}

fn sentences(input: &'_ str) -> SentenceIter<'_> {
    SentenceIter { rest: input.trim() }
}

impl<'a> Iterator for SentenceIter<'a> {
    type Item = &'a str;

    fn next(&mut self) -> Option<Self::Item> {
        if self.rest.is_empty() {
            return None;
        }
        let Some(punct_i) = self.rest.find(&['!', '?', '.']) else {
            let ret = self.rest;
            self.rest = "";
            return Some(ret.trim());
        };
        let (ret, left) = self.rest.split_at(punct_i + 1);
        self.rest = left.trim_start();
        return Some(ret.trim());
    }
}

fn determine_sentence_type(s: &str) -> Option<SentenceType> {
    match s.chars().last() {
        Some('!') => Some(SentenceType::Exclamation),
        Some('?') => Some(SentenceType::Question),
        Some('.') => Some(SentenceType::Serious),
        Some(_) => Some(SentenceType::Neutral),
        None => None
    }
}

fn main() {
    let s = "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it";
    let si = sentences(s);

    for s in si {
        println!("\"{}\" → {:?}", s, determine_sentence_type(s).unwrap());
    }
}
