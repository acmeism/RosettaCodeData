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

fn number_name(n: usize, ordinal: bool) -> String {
    if n < 20 {
        return String::from(SMALL_NAMES[n].get_name(ordinal));
    } else if n < 100 {
        if n % 10 == 0 {
            return String::from(TENS[n / 10 - 2].get_name(ordinal));
        }
        let s1 = TENS[n / 10 - 2].get_name(false);
        let s2 = SMALL_NAMES[n % 10].get_name(ordinal);
        return format!("{}-{}", s1, s2);
    }
    let big = big_name(n);
    let mut result = number_name(n / big.number, false);
    result.push(' ');
    if n % big.number == 0 {
        result.push_str(big.get_name(ordinal));
    } else {
        result.push_str(big.get_name(false));
        result.push(' ');
        result.push_str(&number_name(n % big.number, ordinal));
    }
    result
}

fn test_ordinal(n: usize) {
    println!("{}: {}", n, number_name(n, true));
}

fn main() {
    test_ordinal(1);
    test_ordinal(2);
    test_ordinal(3);
    test_ordinal(4);
    test_ordinal(5);
    test_ordinal(11);
    test_ordinal(15);
    test_ordinal(21);
    test_ordinal(42);
    test_ordinal(65);
    test_ordinal(98);
    test_ordinal(100);
    test_ordinal(101);
    test_ordinal(272);
    test_ordinal(300);
    test_ordinal(750);
    test_ordinal(23456);
    test_ordinal(7891233);
    test_ordinal(8007006005004003);
}
