// cargo-deps: time="0.1"
extern crate time;

use std::thread;
use std::time::Duration;

const TOP: &str = " ⡎⢉⢵ ⠀⢺⠀ ⠊⠉⡱ ⠊⣉⡱ ⢀⠔⡇ ⣏⣉⡉ ⣎⣉⡁ ⠊⢉⠝ ⢎⣉⡱ ⡎⠉⢱ ⠀⠶⠀";
const BOT: &str = " ⢗⣁⡸ ⢀⣸⣀ ⣔⣉⣀ ⢄⣀⡸ ⠉⠉⡏ ⢄⣀⡸ ⢇⣀⡸ ⢰⠁⠀ ⢇⣀⡸ ⢈⣉⡹ ⠀⠶⠀";

fn main() {
    let top: Vec<&str> = TOP.split_whitespace().collect();
    let bot: Vec<&str> = BOT.split_whitespace().collect();

    loop {
        let tm = &time::now().rfc822().to_string()[17..25];
        let top_str: String = tm.chars().map(|x| top[x as usize - '0' as usize]).collect();
        let bot_str: String = tm.chars().map(|x| bot[x as usize - '0' as usize]).collect();

        clear_screen();
        println!("{}", top_str);
        println!("{}", bot_str);

        thread::sleep(Duration::from_secs(1));
    }
}

fn clear_screen() {
    println!("{}[H{}[J", 27 as char, 27 as char);
}
