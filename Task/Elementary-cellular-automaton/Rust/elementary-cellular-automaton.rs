fn main() {
    struct ElementaryCA {
        rule: u8,
        state: u64,
    }
    impl ElementaryCA {
        fn new(rule: u8) -> (u64, ElementaryCA) {
            let out = ElementaryCA {
                rule,
                state: 1,
            };
            (out.state, out)
        }
        fn next(&mut self) -> u64 {
            let mut next_state = 0u64;
            let state = self.state;
            for i in 0..64 {
                next_state |= (((self.rule as u64)>>(7 & (state.rotate_left(1).rotate_right(i as u32)))) & 1)<<i;
            }
            self.state = next_state;
            self.state
        }
    }
    fn rep_u64(val: u64) -> String {
        let mut out = String::new();
        for i in (0..64).rev() {
            if 1<<i & val != 0 {
                out = out + "\u{2588}";
            } else {
                out = out + "-";
            }
        }
        out
    }

    let (i, mut thirty) = ElementaryCA::new(154);
    println!("{}",rep_u64(i));
    for _ in 0..32 {
        let s = thirty.next();
        println!("{}", rep_u64(s));
    }
}
