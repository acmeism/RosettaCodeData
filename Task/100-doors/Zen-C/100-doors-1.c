fn main() {
    let doors: [bool; 100];
    for i in 0..100 { doors[i] = true; }
    for i in 1..=100 {
        let j = i;
        while j < 100 {
            doors[j] = !doors[j];
            j += i + 1;
        }
    }
    for i in 0..100 {
        if doors[i] { print "{i + 1} "; }
    }
    println "";
}
