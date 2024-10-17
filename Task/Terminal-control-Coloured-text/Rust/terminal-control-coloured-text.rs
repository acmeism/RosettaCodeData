const ESC: &str = "\x1B[";
const RESET: &str = "\x1B[0m";

fn main() {
    println!("Foreground¦Background--------------------------------------------------------------");
    print!("          ¦");
    for i in 40..48 {
        print!(" ESC[{}m ", i);
    }
    println!("\n----------¦------------------------------------------------------------------------");
    for i in 30..38 {
        print!("{}ESC[{}m   ¦{}{1}m", RESET, i, ESC);
        for j in 40..48 {
            print!("{}{}m Rosetta ", ESC, j);
        }
        println!("{}", RESET);
        print!("{}ESC[{};1m ¦{}{1};1m", RESET, i, ESC);
        for j in 40..48 {
            print!("{}{}m Rosetta ", ESC, j);
        }
        println!("{}", RESET);
    }
}
