//Assuming the code from the Elementary cellular automaton task is in the namespace.
fn main() {
    struct WolfGen(ElementaryCA);
    impl WolfGen {
        fn new() -> WolfGen {
            let (_, ca) = ElementaryCA::new(30);
            WolfGen(ca)
        }
        fn next(&mut self) -> u8 {
            let mut out = 0;
            for i in 0..8 {
                out |= ((1 & self.0.next())<<i)as u8;
            }
            out
        }
    }
    let mut gen = WolfGen::new();
    for _ in 0..10 {
        print!("{} ", gen.next());
    }
}
