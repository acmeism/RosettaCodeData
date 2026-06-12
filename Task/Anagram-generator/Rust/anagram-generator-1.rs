/// For phrases with multiple white spaces, we want to return a sequence of arrays that correspond
/// with different-length words that add up to the same character count.
///
/// Ex: `"pizza party time"` has 2 spaces and 14 characters, so we can create 19 unique combinations
/// of phrases that use the same number of characters and spaces.
///
/// `[[1, 1, 12], [1, 2, 11], [1, 3, 10], ...etc.]`
struct Sums {
    char_count: usize,
    current: Box<[usize]>,
    done: bool,
}

impl Sums {
    fn from_counts(word_count: usize, char_count: usize) -> Sums {
        Sums {
            char_count,
            current: vec![1; word_count].into(),
            done: false,
        }
    }

    fn sum(&self) -> usize {
        self.current.iter().sum()
    }

    fn is_valid(&self) -> bool {
        self.sum() == self.char_count
    }

    /// Advances the current array to next lexicographic-like array starting at the end
    fn advance(&mut self) {
        let len = self.current.len();

        for i in (0..len).rev() {
            if self.current[i] < self.char_count {
                self.current[i] += 1;

                // Only called if not on last index, meaning we have to reset those values
                for j in i + 1..len {
                    self.current[j] = self.current[i];
                }

                if Self::sum(self) <= self.char_count {
                    return;
                }

                // We incremented too high, we have to go back previous index
            }
        }
        self.done = true;
    }
}

impl Iterator for Sums {
    type Item = Box<[usize]>;

    fn next(&mut self) -> Option<Self::Item> {
        while !self.done {
            if self.is_valid() {
                let result = self.current.clone();
                self.advance();
                return Some(result);
            }
            self.advance();
        }
        None
    }
}
