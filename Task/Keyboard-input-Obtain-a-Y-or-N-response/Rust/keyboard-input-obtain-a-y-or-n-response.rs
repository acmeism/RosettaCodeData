//cargo-deps: ncurses

extern crate ncurses;
use ncurses::*;

fn main() {
    initscr();
    loop {
        printw("Yes or no? ");
        refresh();

        match getch() as u8 as char {
            'Y'|'y' => {printw("You said yes!");},
            'N'|'n' => {printw("You said no!");},
            _ => {printw("Try again!\n"); continue;},
        }
        break
    }
    refresh();
    endwin();
}
