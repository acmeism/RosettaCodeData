trait IteratorTrait {
    fn has_next(&self) -> bool;
    fn next(&mut self) -> i64;
}

struct CFData<'a> {
    text: String,
    args: Vec<i64>,
    iterator: Box<dyn IteratorTrait + 'a>,
}

struct R2cfIterator {
    numerator: i64,
    denominator: i64,
}

impl IteratorTrait for R2cfIterator {
    fn has_next(&self) -> bool {
        self.denominator != 0
    }

    fn next(&mut self) -> i64 {
        let div = self.numerator / self.denominator;
        let rem = self.numerator % self.denominator;
        self.numerator = self.denominator;
        self.denominator = rem;
        div
    }
}

struct Root2 {
    first_return: bool,
}

impl IteratorTrait for Root2 {
    fn has_next(&self) -> bool {
        true
    }

    fn next(&mut self) -> i64 {
        if self.first_return {
            self.first_return = false;
            1
        } else {
            2
        }
    }
}

struct ReciprocalRoot2 {
    first_return: bool,
    second_return: bool,
}

impl IteratorTrait for ReciprocalRoot2 {
    fn has_next(&self) -> bool {
        true
    }

    fn next(&mut self) -> i64 {
        if self.first_return {
            self.first_return = false;
            0
        } else if self.second_return {
            self.second_return = false;
            1
        } else {
            2
        }
    }
}

struct NG {
    a1: i64,
    a: i64,
    b1: i64,
    b: i64,
}

impl NG {
    fn new(args: &[i64]) -> Self {
        NG {
            a1: args[0],
            a: args[1],
            b1: args[2],
            b: args[3],
        }
    }

    fn ingress(&mut self, a_n: i64) {
        let temp = self.a;
        self.a = self.a1;
        self.a1 = temp + self.a1 * a_n;
        let temp = self.b;
        self.b = self.b1;
        self.b1 = temp + self.b1 * a_n;
    }

    fn egress(&mut self) -> i64 {
        let n = self.a / self.b;
        let temp = self.a;
        self.a = self.b;
        self.b = temp - self.b * n;
        let temp = self.a1;
        self.a1 = self.b1;
        self.b1 = temp - self.b1 * n;
        n
    }

    fn needs_term(&self) -> bool {
        self.b == 0 || self.b1 == 0 || self.a * self.b1 != self.a1 * self.b
    }

    fn egress_done(&mut self) -> i64 {
        if self.needs_term() {
            self.a = self.a1;
            self.b = self.b1;
        }
        self.egress()
    }

    fn done(&self) -> bool {
        self.b == 0 || self.b1 == 0
    }
}

fn main() {
    let cf_data = vec![
        CFData {
            text: String::from("[1; 5, 2] + 1 / 2"),
            args: vec![2, 1, 0, 2],
            iterator: Box::new(R2cfIterator {
                numerator: 13,
                denominator: 11,
            }),
        },
        CFData {
            text: String::from("[3; 7] + 1 / 2"),
            args: vec![2, 1, 0, 2],
            iterator: Box::new(R2cfIterator {
                numerator: 22,
                denominator: 7,
            }),
        },
        CFData {
            text: String::from("[3; 7] divided by 4"),
            args: vec![1, 0, 0, 4],
            iterator: Box::new(R2cfIterator {
                numerator: 22,
                denominator: 7,
            }),
        },
        CFData {
            text: String::from("sqrt(2)"),
            args: vec![0, 1, 1, 0],
            iterator: Box::new(Root2 { first_return: true }),
        },
        CFData {
            text: String::from("1 / sqrt(2)"),
            args: vec![0, 1, 1, 0],
            iterator: Box::new(ReciprocalRoot2 {
                first_return: true,
                second_return: true,
            }),
        },
        CFData {
            text: String::from("(1 + sqrt(2)) / 2"),
            args: vec![1, 1, 0, 2],
            iterator: Box::new(Root2 { first_return: true }),
        },
        CFData {
            text: String::from("(1 + 1 / sqrt(2)) / 2"),
            args: vec![1, 1, 0, 2],
            iterator: Box::new(ReciprocalRoot2 {
                first_return: true,
                second_return: true,
            }),
        },
    ];

    for data in cf_data {
        print!("{} -> ", data.text);
        let mut ng = NG::new(&data.args);
        let mut iterator = data.iterator;
        let mut next_term = 0;
        for _ in 1..=20 {
            if !iterator.has_next() {
                break;
            }
            next_term = iterator.next();
            if !ng.needs_term() {
                print!("{} ", ng.egress());
            }
            ng.ingress(next_term);
        }
        while !ng.done() {
            print!("{} ", ng.egress_done());
        }
        println!();
    }
}
