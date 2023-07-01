#[derive(Clone, Debug)]
pub struct LineComposer<I> {
    words: I,
    width: usize,
    current: Option<String>,
}

impl<I> LineComposer<I> {
    pub(crate) fn new<S>(words: I, width: usize) -> Self
    where
        I: Iterator<Item = S>,
        S: AsRef<str>,
    {
        LineComposer {
            words,
            width,
            current: None,
        }
    }
}

impl<I, S> Iterator for LineComposer<I>
where
    I: Iterator<Item = S>,
    S: AsRef<str>,
{
    type Item = String;

    fn next(&mut self) -> Option<Self::Item> {
        let mut next = match self.words.next() {
            None => return self.current.take(),
            Some(value) => value,
        };

        let mut current = self.current.take().unwrap_or_else(String::new);

        loop {
            let word = next.as_ref();
            if self.width <= current.len() + word.len() {
                self.current = Some(String::from(word));
                // If the first word itself is too long, avoid producing an
                // empty line. Continue instead with the next word.
                if !current.is_empty() {
                    return Some(current);
                }
            }

            if !current.is_empty() {
                current.push_str(" ")
            }

            current.push_str(word);

            match self.words.next() {
                None => return Some(current), // Last line, current remains None
                Some(word) => next = word,
            }
        }
    }
}

// This part is just to extend all suitable iterators with LineComposer

pub trait ComposeLines: Iterator {
    fn compose_lines(self, width: usize) -> LineComposer<Self>
    where
        Self: Sized,
        Self::Item: AsRef<str>,
    {
        LineComposer::new(self, width)
    }
}

impl<T, S> ComposeLines for T
where
    T: Iterator<Item = S>,
    S: AsRef<str>,
{
}

fn main() {
    let text = r"
        In olden times when wishing still helped one, there lived a king whose
        daughters were all beautiful, but the youngest was so beautiful that the
        sun itself, which has seen so much, was astonished whenever it shone in
        her face. Close by the king's castle lay a great dark forest, and under
        an old lime tree in the forest was a well, and when the day was very
        warm, the king's child went out into the forest and sat down by the side
        of the cool fountain, and when she was bored she took a golden ball, and
        threw it up on high and caught it, and this ball was her favorite
        plaything.";

    text.split_whitespace()
        .compose_lines(80)
        .for_each(|line| println!("{}", line));
}
