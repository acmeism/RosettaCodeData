struct NumberNames {
    cardinal: &'static str,
    ordinal: &'static str,
}

impl NumberNames {
    fn get_name(&self, ordinal: bool) -> &'static str {
        if ordinal {
            return self.ordinal;
        }
        self.cardinal
    }
}

const SMALL_NAMES: [NumberNames; 20] = [
    NumberNames {
        cardinal: "zero",
        ordinal: "zeroth",
    },
    NumberNames {
        cardinal: "one",
        ordinal: "first",
    },
    NumberNames {
        cardinal: "two",
        ordinal: "second",
    },
    NumberNames {
        cardinal: "three",
        ordinal: "third",
    },
    NumberNames {
        cardinal: "four",
        ordinal: "fourth",
    },
    NumberNames {
        cardinal: "five",
        ordinal: "fifth",
    },
    NumberNames {
        cardinal: "six",
        ordinal: "sixth",
    },
    NumberNames {
        cardinal: "seven",
        ordinal: "seventh",
    },
    NumberNames {
        cardinal: "eight",
        ordinal: "eighth",
    },
    NumberNames {
        cardinal: "nine",
        ordinal: "ninth",
    },
    NumberNames {
        cardinal: "ten",
        ordinal: "tenth",
    },
    NumberNames {
        cardinal: "eleven",
        ordinal: "eleventh",
    },
    NumberNames {
        cardinal: "twelve",
        ordinal: "twelfth",
    },
    NumberNames {
        cardinal: "thirteen",
        ordinal: "thirteenth",
    },
    NumberNames {
        cardinal: "fourteen",
        ordinal: "fourteenth",
    },
    NumberNames {
        cardinal: "fifteen",
        ordinal: "fifteenth",
    },
    NumberNames {
        cardinal: "sixteen",
        ordinal: "sixteenth",
    },
    NumberNames {
        cardinal: "seventeen",
        ordinal: "seventeenth",
    },
    NumberNames {
        cardinal: "eighteen",
        ordinal: "eighteenth",
    },
    NumberNames {
        cardinal: "nineteen",
        ordinal: "nineteenth",
    },
];

const TENS: [NumberNames; 8] = [
    NumberNames {
        cardinal: "twenty",
        ordinal: "twentieth",
    },
    NumberNames {
        cardinal: "thirty",
        ordinal: "thirtieth",
    },
    NumberNames {
        cardinal: "forty",
        ordinal: "fortieth",
    },
    NumberNames {
        cardinal: "fifty",
        ordinal: "fiftieth",
    },
    NumberNames {
        cardinal: "sixty",
        ordinal: "sixtieth",
    },
    NumberNames {
        cardinal: "seventy",
        ordinal: "seventieth",
    },
    NumberNames {
        cardinal: "eighty",
        ordinal: "eightieth",
    },
    NumberNames {
        cardinal: "ninety",
        ordinal: "ninetieth",
    },
];

struct NamedNumber {
    cardinal: &'static str,
    ordinal: &'static str,
    number: usize,
}

impl NamedNumber {
    fn get_name(&self, ordinal: bool) -> &'static str {
        if ordinal {
            return self.ordinal;
        }
        self.cardinal
    }
}

const N: usize = 7;
const NAMED_NUMBERS: [NamedNumber; N] = [
    NamedNumber {
        cardinal: "hundred",
        ordinal: "hundredth",
        number: 100,
    },
    NamedNumber {
        cardinal: "thousand",
        ordinal: "thousandth",
        number: 1000,
    },
    NamedNumber {
        cardinal: "million",
        ordinal: "millionth",
        number: 1000000,
    },
    NamedNumber {
        cardinal: "billion",
        ordinal: "billionth",
        number: 1000000000,
    },
    NamedNumber {
        cardinal: "trillion",
        ordinal: "trillionth",
        number: 1000000000000,
    },
    NamedNumber {
        cardinal: "quadrillion",
        ordinal: "quadrillionth",
        number: 1000000000000000,
    },
    NamedNumber {
        cardinal: "quintillion",
        ordinal: "quintillionth",
        number: 1000000000000000000,
    },
];

fn big_name(n: usize) -> &'static NamedNumber {
    for i in 1..N {
        if n < NAMED_NUMBERS[i].number {
            return &NAMED_NUMBERS[i - 1];
        }
    }
    &NAMED_NUMBERS[N - 1]
}

fn count_letters(s: &str) -> usize {
    let mut count = 0;
    for c in s.chars() {
        if c.is_alphabetic() {
            count += 1;
        }
    }
    count
}

struct WordList {
    words: Vec<(usize, usize)>,
    string: String,
}

impl WordList {
    fn new() -> WordList {
        WordList {
            words: Vec::new(),
            string: String::new(),
        }
    }
    fn append(&mut self, s: &str) {
        let offset = self.string.len();
        self.string.push_str(s);
        self.words.push((offset, offset + s.len()));
    }
    fn extend(&mut self, s: &str) {
        let len = self.words.len();
        let mut w = &mut self.words[len - 1];
        w.1 += s.len();
        self.string.push_str(s);
    }
    fn len(&self) -> usize {
        self.words.len()
    }
    fn sentence_length(&self) -> usize {
        let n = self.words.len();
        if n == 0 {
            return 0;
        }
        self.string.len() + n - 1
    }
    fn get_word(&self, index: usize) -> &str {
        let w = &self.words[index];
        &self.string[w.0..w.1]
    }
}

fn append_number_name(words: &mut WordList, n: usize, ordinal: bool) -> usize {
    let mut count = 0;
    if n < 20 {
        words.append(SMALL_NAMES[n].get_name(ordinal));
        count += 1;
    } else if n < 100 {
        if n % 10 == 0 {
            words.append(TENS[n / 10 - 2].get_name(ordinal));
        } else {
            words.append(TENS[n / 10 - 2].get_name(false));
            words.extend("-");
            words.extend(SMALL_NAMES[n % 10].get_name(ordinal));
        }
        count += 1;
    } else {
        let big = big_name(n);
        count += append_number_name(words, n / big.number, false);
        if n % big.number == 0 {
            words.append(big.get_name(ordinal));
            count += 1;
        } else {
            words.append(big.get_name(false));
            count += 1;
            count += append_number_name(words, n % big.number, ordinal);
        }
    }
    count
}

fn sentence(count: usize) -> WordList {
    let mut result = WordList::new();
    const WORDS: &'static [&'static str] = &[
        "Four",
        "is",
        "the",
        "number",
        "of",
        "letters",
        "in",
        "the",
        "first",
        "word",
        "of",
        "this",
        "sentence,",
    ];
    for s in WORDS {
        result.append(s);
    }
    let mut n = result.len();
    let mut i = 1;
    while count > n {
        let count = count_letters(result.get_word(i));
        n += append_number_name(&mut result, count, false);
        result.append("in");
        result.append("the");
        n += 2;
        n += append_number_name(&mut result, i + 1, true);
        result.extend(",");
        i += 1;
    }
    result
}

fn main() {
    let mut n = 201;
    let s = sentence(n);
    println!("Number of letters in first {} words in the sequence:", n);
    for i in 0..n {
        if i != 0 {
            if i % 25 == 0 {
                println!();
            } else {
                print!(" ");
            }
        }
        print!("{:2}", count_letters(s.get_word(i)));
    }
    println!();
    println!("Sentence length: {}", s.sentence_length());
    n = 1000;
    while n <= 10000000 {
        let s = sentence(n);
        let word = s.get_word(n - 1);
        print!(
            "The {}th word is '{}' and has {} letters. ",
            n,
            word,
            count_letters(word)
        );
        println!("Sentence length: {}", s.sentence_length());
        n *= 10;
    }
}
