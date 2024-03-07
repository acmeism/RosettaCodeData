struct Zeckendorf {
    d_val: i32,
    d_len: i32,
}

impl Zeckendorf {
    fn new(x: &str) -> Zeckendorf {
        let mut d_val = 0;
        let mut q = 1;
        let mut i = x.len() as i32 - 1;
        let d_len = i / 2;
        while i >= 0 {
            d_val += (x.chars().nth(i as usize).unwrap() as i32 - '0' as i32) * q;
            q *= 2;
            i -= 1;
        }

        Zeckendorf { d_val, d_len }
    }

    fn a(&mut self, n: i32) {
        let mut i = n;
        loop {
            if self.d_len < i {
                self.d_len = i;
            }
            let j = (self.d_val >> (i * 2)) & 3;
            match j {
                0 | 1 => return,
                2 => {
                    if ((self.d_val >> ((i + 1) * 2)) & 1) != 1 {
                        return;
                    }
                    self.d_val += 1 << (i * 2 + 1);
                    return;
                }
                3 => {
                    let temp = 3 << (i * 2);
                    let temp = !temp;
                    self.d_val &= temp;
                    self.b((i + 1) * 2);
                }
                _ => (),
            }
            i += 1;
        }
    }

    fn b(&mut self, pos: i32) {
        if pos == 0 {
            self.inc();
            return;
        }
        if ((self.d_val >> pos) & 1) == 0 {
            self.d_val += 1 << pos;
            self.a(pos / 2);
            if pos > 1 {
                self.a(pos / 2 - 1);
            }
        } else {
            let temp = 1 << pos;
            let temp = !temp;
            self.d_val &= temp;
            self.b(pos + 1);
            self.b(pos - if pos > 1 { 2 } else { 1 });
        }
    }

    fn c(&mut self, pos: i32) {
        if ((self.d_val >> pos) & 1) == 1 {
            let temp = 1 << pos;
            let temp = !temp;
            self.d_val &= temp;
            return;
        }
        self.c(pos + 1);
        if pos > 0 {
            self.b(pos - 1);
        } else {
            self.inc();
        }
    }

    fn inc(&mut self) -> &mut Self {
        self.d_val += 1;
        self.a(0);
        self
    }

    fn copy(&self) -> Zeckendorf {
        Zeckendorf {
            d_val: self.d_val,
            d_len: self.d_len,
        }
    }

    fn plus_assign(&mut self, other: &Zeckendorf) {
        for gn in 0..(other.d_len + 1) * 2 {
            if ((other.d_val >> gn) & 1) == 1 {
                self.b(gn);
            }
        }
    }

    fn minus_assign(&mut self, other: &Zeckendorf) {
        for gn in 0..(other.d_len + 1) * 2 {
            if ((other.d_val >> gn) & 1) == 1 {
                self.c(gn);
            }
        }
        while (((self.d_val >> self.d_len * 2) & 3) == 0) || (self.d_len == 0) {
            self.d_len -= 1;
        }
    }

    fn times_assign(&mut self, other: &Zeckendorf) {
        let mut na = other.copy();
        let mut nb = other.copy();
        let mut nt;
        let mut nr = Zeckendorf::new("0");
        for i in 0..(self.d_len + 1) * 2 {
            if ((self.d_val >> i) & 1) > 0 {
                nr.plus_assign(&nb);
            }
            nt = nb.copy();
            nb.plus_assign(&na);
            na = nt.copy(); // `na` is now mutable, so this reassignment is allowed
        }
        self.d_val = nr.d_val;
        self.d_len = nr.d_len;
    }

    fn to_string(&self) -> String {
        if self.d_val == 0 {
            return "0".to_string();
        }

        let dig = ["00", "01", "10"];
        let dig1 = ["", "1", "10"];

        let idx = (self.d_val >> (self.d_len * 2)) & 3;
        let mut sb = String::from(dig1[idx as usize]);
        for i in (0..self.d_len).rev() {
            let idx = (self.d_val >> (i * 2)) & 3;
            sb.push_str(dig[idx as usize]);
        }
        sb
    }
}

fn main() {
    println!("Addition:");
    let mut g = Zeckendorf::new("10");
    g.plus_assign(&Zeckendorf::new("10"));
    println!("{}", g.to_string());
    g.plus_assign(&Zeckendorf::new("10"));
    println!("{}", g.to_string());
    g.plus_assign(&Zeckendorf::new("1001"));
    println!("{}", g.to_string());
    g.plus_assign(&Zeckendorf::new("1000"));
    println!("{}", g.to_string());
    g.plus_assign(&Zeckendorf::new("10101"));
    println!("{}", g.to_string());
    println!();

    println!("Subtraction:");
    g = Zeckendorf::new("1000");
    g.minus_assign(&Zeckendorf::new("101"));
    println!("{}", g.to_string());
    g = Zeckendorf::new("10101010");
    g.minus_assign(&Zeckendorf::new("1010101"));
    println!("{}", g.to_string());
    println!();

    println!("Multiplication:");
    g = Zeckendorf::new("1001");
    g.times_assign(&Zeckendorf::new("101"));
    println!("{}", g.to_string());
    g = Zeckendorf::new("101010");
    g.plus_assign(&Zeckendorf::new("101"));
    println!("{}", g.to_string());
}
