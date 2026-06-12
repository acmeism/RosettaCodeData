// Trait for continued fraction representations
trait ContinuedFraction {
    fn has_more_terms(&mut self) -> bool;
    fn next_term(&mut self) -> i64;
}

// Rational to continued fraction converter
struct R2cf {
    n1: i64,
    n2: i64,
}

impl R2cf {
    fn new(n1: i64, n2: i64) -> Self {
        Self { n1, n2 }
    }
}

impl ContinuedFraction for R2cf {
    fn has_more_terms(&mut self) -> bool {
        self.n2.abs() > 0
    }

    fn next_term(&mut self) -> i64 {
        let term = self.n1 / self.n2;
        let temp = self.n2;
        self.n2 = self.n1 - term * self.n2;
        self.n1 = temp;
        term
    }
}

// Base trait for matrix operations
trait MatrixNG {
    fn consume_term(&mut self);
    fn consume_term_with_n(&mut self, n: i64);
    fn needs_term(&mut self) -> bool;
    fn get_configuration(&self) -> usize;
    fn get_current_term(&self) -> i64;
    fn has_term(&self) -> bool;
    fn set_has_term(&mut self, value: bool);
}

// 4-element matrix for single continued fraction operations
struct NG4 {
    a1: i64,
    a: i64,
    b1: i64,
    b: i64,
    current_term: i64,
    has_term: bool,
}

impl NG4 {
    fn new(a1: i64, a: i64, b1: i64, b: i64) -> Self {
        Self {
            a1,
            a,
            b1,
            b,
            current_term: 0,
            has_term: false,
        }
    }
}

impl MatrixNG for NG4 {
    fn consume_term(&mut self) {
        self.a = self.a1;
        self.b = self.b1;
    }

    fn consume_term_with_n(&mut self, n: i64) {
        let temp = self.a;
        self.a = self.a1;
        self.a1 = temp + self.a1 * n;
        let temp = self.b;
        self.b = self.b1;
        self.b1 = temp + self.b1 * n;
    }

    fn needs_term(&mut self) -> bool {
        if self.b1 == 0 && self.b == 0 {
            return false;
        }
        if self.b1 == 0 || self.b == 0 {
            return true;
        }

        self.current_term = self.a / self.b;
        if self.current_term == self.a1 / self.b1 {
            let temp = self.a;
            self.a = self.b;
            self.b = temp - self.b * self.current_term;
            let temp = self.a1;
            self.a1 = self.b1;
            self.b1 = temp - self.b1 * self.current_term;

            self.has_term = true;
            return false;
        }
        true
    }

    fn get_configuration(&self) -> usize {
        0
    }

    fn get_current_term(&self) -> i64 {
        self.current_term
    }

    fn has_term(&self) -> bool {
        self.has_term
    }

    fn set_has_term(&mut self, value: bool) {
        self.has_term = value;
    }
}

// 8-element matrix for two continued fraction operations
struct NG8 {
    a12: i64,
    a1: i64,
    a2: i64,
    a: i64,
    b12: i64,
    b1: i64,
    b2: i64,
    b: i64,
    ab: f64,
    a1b1: f64,
    a2b2: f64,
    a12b12: f64,
    configuration: usize,
    current_term: i64,
    has_term: bool,
}

impl NG8 {
    fn new(a12: i64, a1: i64, a2: i64, a: i64, b12: i64, b1: i64, b2: i64, b: i64) -> Self {
        Self {
            a12,
            a1,
            a2,
            a,
            b12,
            b1,
            b2,
            b,
            ab: 0.0,
            a1b1: 0.0,
            a2b2: 0.0,
            a12b12: 0.0,
            configuration: 0,
            current_term: 0,
            has_term: false,
        }
    }

    fn set_configuration(&self) -> usize {
        if (self.a1b1 - self.ab).abs() > (self.a2b2 - self.ab).abs() {
            0
        } else {
            1
        }
    }
}

impl MatrixNG for NG8 {
    fn consume_term(&mut self) {
        if self.configuration == 0 {
            self.a = self.a1;
            self.a2 = self.a12;
            self.b = self.b1;
            self.b2 = self.b12;
        } else {
            self.a = self.a2;
            self.a1 = self.a12;
            self.b = self.b2;
            self.b1 = self.b12;
        }
    }

    fn consume_term_with_n(&mut self, n: i64) {
        if self.configuration == 0 {
            let temp = self.a;
            self.a = self.a1;
            self.a1 = temp + self.a1 * n;
            let temp = self.a2;
            self.a2 = self.a12;
            self.a12 = temp + self.a12 * n;
            let temp = self.b;
            self.b = self.b1;
            self.b1 = temp + self.b1 * n;
            let temp = self.b2;
            self.b2 = self.b12;
            self.b12 = temp + self.b12 * n;
        } else {
            let temp = self.a;
            self.a = self.a2;
            self.a2 = temp + self.a2 * n;
            let temp = self.a1;
            self.a1 = self.a12;
            self.a12 = temp + self.a12 * n;
            let temp = self.b;
            self.b = self.b2;
            self.b2 = temp + self.b2 * n;
            let temp = self.b1;
            self.b1 = self.b12;
            self.b12 = temp + self.b12 * n;
        }
    }

    fn needs_term(&mut self) -> bool {
        if self.b1 == 0 && self.b == 0 && self.b2 == 0 && self.b12 == 0 {
            return false;
        }

        if self.b == 0 {
            self.configuration = if self.b2 == 0 { 0 } else { 1 };
            return true;
        }
        self.ab = self.a as f64 / self.b as f64;

        if self.b2 == 0 {
            self.configuration = 1;
            return true;
        }
        self.a2b2 = self.a2 as f64 / self.b2 as f64;

        if self.b1 == 0 {
            self.configuration = 0;
            return true;
        }
        self.a1b1 = self.a1 as f64 / self.b1 as f64;

        if self.b12 == 0 {
            self.configuration = self.set_configuration();
            return true;
        }
        self.a12b12 = self.a12 as f64 / self.b12 as f64;

        self.current_term = self.ab.floor() as i64;
        if self.current_term == self.a1b1.floor() as i64
            && self.current_term == self.a2b2.floor() as i64
            && self.current_term == self.a12b12.floor() as i64
        {
            let temp = self.a;
            self.a = self.b;
            self.b = temp - self.b * self.current_term;
            let temp = self.a1;
            self.a1 = self.b1;
            self.b1 = temp - self.b1 * self.current_term;
            let temp = self.a2;
            self.a2 = self.b2;
            self.b2 = temp - self.b2 * self.current_term;
            let temp = self.a12;
            self.a12 = self.b12;
            self.b12 = temp - self.b12 * self.current_term;

            self.has_term = true;
            return false;
        }
        self.configuration = self.set_configuration();
        true
    }

    fn get_configuration(&self) -> usize {
        self.configuration
    }

    fn get_current_term(&self) -> i64 {
        self.current_term
    }

    fn has_term(&self) -> bool {
        self.has_term
    }

    fn set_has_term(&mut self, value: bool) {
        self.has_term = value;
    }
}

// Generic continued fraction generator
struct NG<M: MatrixNG> {
    matrix_ng: M,
    cf: Vec<Box<dyn ContinuedFraction>>,
}

impl<M: MatrixNG> NG<M> {
    fn new(matrix_ng: M, cf1: Box<dyn ContinuedFraction>) -> Self {
        Self {
            matrix_ng,
            cf: vec![cf1],
        }
    }

    fn with_two_cf(matrix_ng: M, cf1: Box<dyn ContinuedFraction>, cf2: Box<dyn ContinuedFraction>) -> Self {
        Self {
            matrix_ng,
            cf: vec![cf1, cf2],
        }
    }
}

impl<M: MatrixNG> ContinuedFraction for NG<M> {
    fn has_more_terms(&mut self) -> bool {
        while self.matrix_ng.needs_term() {
            let config = self.matrix_ng.get_configuration();
            if config < self.cf.len() && self.cf[config].has_more_terms() {
                let term = self.cf[config].next_term();
                self.matrix_ng.consume_term_with_n(term);
            } else {
                self.matrix_ng.consume_term();
            }
        }
        self.matrix_ng.has_term()
    }

    fn next_term(&mut self) -> i64 {
        self.matrix_ng.set_has_term(false);
        self.matrix_ng.get_current_term()
    }
}

fn test_fractions(description: &str, fractions: &mut [&mut dyn ContinuedFraction]) {
    println!("Testing: {}", description);

    for fraction in fractions {
        let mut terms = Vec::new();
        while fraction.has_more_terms() {
            terms.push(fraction.next_term().to_string());
        }
        println!("{}", terms.join(" "));
    }

    println!();
}

fn main() {
    // [3; 7] + [0; 2]
    let mut ng1 = NG::with_two_cf(
        NG8::new(0, 1, 1, 0, 0, 0, 0, 1),
        Box::new(R2cf::new(1, 2)),
        Box::new(R2cf::new(22, 7)),
    );
    let mut ng2 = NG::new(
        NG4::new(2, 1, 0, 2),
        Box::new(R2cf::new(22, 7)),
    );
    test_fractions("[3; 7] + [0; 2]", &mut [&mut ng1, &mut ng2]);

    // [1; 5, 2] * [3; 7]
    let mut ng3 = NG::with_two_cf(
        NG8::new(1, 0, 0, 0, 0, 0, 0, 1),
        Box::new(R2cf::new(13, 11)),
        Box::new(R2cf::new(22, 7)),
    );
    let mut r2cf1 = R2cf::new(286, 77);
    test_fractions("[1; 5, 2] * [3; 7]", &mut [&mut ng3, &mut r2cf1]);

    // [1; 5, 2] - [3; 7]
    let mut ng4 = NG::with_two_cf(
        NG8::new(0, 1, -1, 0, 0, 0, 0, 1),
        Box::new(R2cf::new(13, 11)),
        Box::new(R2cf::new(22, 7)),
    );
    let mut r2cf2 = R2cf::new(-151, 77);
    test_fractions("[1; 5, 2] - [3; 7]", &mut [&mut ng4, &mut r2cf2]);

    // Divide [] by [3; 7]
    let mut ng5 = NG::with_two_cf(
        NG8::new(0, 1, 0, 0, 0, 0, 1, 0),
        Box::new(R2cf::new(22 * 22, 7 * 7)),
        Box::new(R2cf::new(22, 7)),
    );
    test_fractions("Divide [] by [3; 7]", &mut [&mut ng5]);

    // ([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])
    let inner_ng1 = NG::with_two_cf(
        NG8::new(0, 1, 1, 0, 0, 0, 0, 1),
        Box::new(R2cf::new(2, 7)),
        Box::new(R2cf::new(13, 11)),
    );
    let inner_ng2 = NG::with_two_cf(
        NG8::new(0, 1, -1, 0, 0, 0, 0, 1),
        Box::new(R2cf::new(2, 7)),
        Box::new(R2cf::new(13, 11)),
    );
    let mut ng6 = NG::with_two_cf(
        NG8::new(1, 0, 0, 0, 0, 0, 0, 1),
        Box::new(inner_ng1),
        Box::new(inner_ng2),
    );
    let mut r2cf3 = R2cf::new(-7797, 5929);
    test_fractions("([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])", &mut [&mut ng6, &mut r2cf3]);
}
