#![warn(clippy::pedantic)] // make sure that clippy is even more annoying

use rand::prelude::{ThreadRng, SliceRandom};
use rand::{thread_rng, Rng};
use termion::{color::Rgb};
use termion::input::TermRead;
use termion::raw::IntoRawMode;
use std::sync::mpsc::{channel, TryRecvError};
use std::thread;
use std::{io::{Write, stdout, stdin}, iter::repeat, time::Duration};

/// Character pool to pick from
/// If your terminal is struggling with that choice, replace them by ordinary latin characters.
/// There's currently no nicer way to initialize constant array in Rust
const CHARS: [char; 322] = [
    'M', 'Ї', 'Љ', 'Њ', 'Ћ', 'Ќ', 'Ѝ', 'Ў', 'Џ', 'Б', 'Г', 'Д', 'Ж', 'И', 'Й', 'Л', 'П', 'Ф', 'Ц', 'Ч', 'Ш', 'Щ', 'Ъ',
    'Ы', 'Э', 'Ю', 'Я', 'в', 'д', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'п', 'т', 'ф', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы',
    'ь', 'э', 'ю', 'я', 'ѐ', 'ё', 'ђ', 'ѓ', 'є', 'ї', 'љ', 'њ', 'ћ', 'ќ', 'ѝ', 'ў', 'џ', 'Ѣ', 'ѣ', 'ѧ', 'Ѯ', 'ѱ', 'Ѳ',
    'ѳ', 'ҋ', 'Ҍ', 'ҍ', 'Ҏ', 'ҏ', 'Ґ', 'ґ', 'Ғ', 'ғ', 'Ҕ', 'ҕ', 'Җ', 'җ', 'Ҙ', 'ҙ', 'Қ', 'қ', 'ҝ', 'ҟ', 'ҡ', 'Ң', 'ң',
    'Ҥ', 'ҥ', 'ҩ', 'Ҫ', 'ҫ', 'Ҭ', 'ҭ', 'Ұ', 'ұ', 'Ҳ', 'ҳ', 'ҵ', 'ҷ', 'ҹ', 'Һ', 'ҿ', 'Ӂ', 'ӂ', 'Ӄ', 'ӄ', 'ӆ', 'Ӈ', 'ӈ',
    'ӊ', 'Ӌ', 'ӌ', 'ӎ', 'Ӑ', 'ӑ', 'Ӓ', 'ӓ', 'Ӕ', 'ӕ', 'Ӗ', 'ӗ', 'Ә', 'ә', 'Ӛ', 'ӛ', 'Ӝ', 'ӝ', 'Ӟ', 'ӟ', 'ӡ', 'Ӣ', 'ӣ',
    'Ӥ', 'ӥ', 'Ӧ', 'ӧ', 'Ө', 'ө', 'Ӫ', 'ӫ', 'Ӭ', 'ӭ', 'Ӯ', 'ӯ', 'Ӱ', 'ӱ', 'Ӳ', 'ӳ', 'Ӵ', 'ӵ', 'Ӷ', 'ӷ', 'Ӹ', 'ӹ', 'Ӻ',
    'ӽ', 'ӿ', 'Ԁ', 'ԍ', 'ԏ', 'Ԑ', 'ԑ', 'ԓ', 'Ԛ', 'ԟ', 'Ԧ', 'ԧ', 'Ϥ', 'ϥ', 'ϫ', 'ϭ', 'ｩ', 'ｪ', 'ｫ', 'ｬ', 'ｭ', 'ｮ', 'ｯ',
    'ｰ', 'ｱ', 'ｲ', 'ｳ', 'ｴ', 'ｵ', 'ｶ', 'ｷ', 'ｸ', 'ｹ', 'ｺ', 'ｻ', 'ｼ', 'ｽ', 'ｾ', 'ｿ', 'ﾀ', 'ﾁ', 'ﾂ', 'ﾃ', 'ﾄ', 'ﾅ', 'ﾆ',
    'ﾇ', 'ﾈ', 'ﾉ', 'ﾊ', 'ﾋ', 'ﾌ', 'ﾍ', 'ﾎ', 'ﾏ', 'ﾐ', 'ﾑ', 'ﾒ', 'ﾓ', 'ﾔ', 'ﾕ', 'ﾖ', 'ﾗ', 'ﾘ', 'ﾙ', 'ﾚ', 'ﾛ', 'ﾜ', 'ﾝ',
    'ⲁ', 'Ⲃ', 'ⲃ', 'Ⲅ', 'Γ', 'Δ', 'Θ', 'Λ', 'Ξ', 'Π', 'Ѐ', 'Ё', 'Ђ', 'Ѓ', 'Є', 'ⲉ', 'Ⲋ', 'ⲋ', 'Ⲍ', 'ⲍ', 'ⲏ', 'ⲑ', 'ⲓ',
    'ⲕ', 'ⲗ', 'ⲙ', 'ⲛ', 'Ⲝ', 'ⲝ', 'ⲡ', 'ⲧ', 'ⲩ', 'ⲫ', 'ⲭ', 'ⲯ', 'ⳁ', 'Ⳉ', 'ⳉ', 'ⳋ', 'ⳤ', '⳥', '⳦', '⳨', '⳩', '∀', '∁',
    '∂', '∃', '∄', '∅', '∆', '∇', '∈', '∉', '∊', '∋', '∌', '∍', '∎', '∏', '∐', '∑', '∓', 'ℇ', 'ℏ', '℥', 'Ⅎ', 'ℷ', '⩫',
    '⨀', '⨅', '⨆', '⨉', '⨍', '⨎', '⨏', '⨐', '⨑', '⨒', '⨓', '⨔', '⨕', '⨖', '⨗', '⨘', '⨙', '⨚', '⨛', '⨜', '⨝', '⨿', '⩪',
    ];

/// convert a brightness value to a green-ish gradient color
fn color(brightness: u8) -> Rgb {
    let v = f32::from(brightness) / 255.0;
    let r = v.powi(7);
    let g = v.powi(1);
    let b = v.powi(4);
    // r, g, b will be in 0.0..=1.0 so there's no risk of exceeding the u8's range
    #[allow(clippy::cast_possible_truncation, clippy::cast_sign_loss)]
    Rgb ((r * 255.0).round() as u8, (g * 255.0).round() as u8, (b * 255.0).round() as u8)
}

/// A single character on the screen with its current brightness
#[derive(Clone, Copy)]
struct Symbol {
    char: char,
    brightness: u8,
}

/// Start with a black space by default
impl Default for Symbol {
    fn default() -> Self {
        Self { char: ' ', brightness: 0 }
    }
}

impl Symbol {
    /// output the colored symbol at the current cursor position
    fn print<W: Write>(self, out: &mut W) {
        write!(out, "{}{}", termion::color::Fg(color(self.brightness)), self.char).unwrap();
    }

    /// reduce the brightness of the symbol by a certain amount and make sure the value doesn't underrun
    fn darken(&mut self) {
        self.brightness = self.brightness.saturating_sub(10);
    }

    /// replace the character for this symbol and bring it to full brightness
    fn set(&mut self, char: char) {
        self.char = char;
        self.brightness = 255;
    }
}

/// a single column of symbols
#[derive(Clone)]
struct Column {
    symbols: Vec<Symbol>,
}

impl Column {
    /// create a new column with a given height
    fn new(height: usize) -> Self {
        Self {
            symbols: vec![Symbol::default(); height],
        }
    }

    /// print out a single colored symbol of this column
    fn print_symbol<W: Write>(&self, out: &mut W, row: usize) {
        self.symbols[row].print(out);
    }

    /// reduce the brightness of the entire column
    fn darken(&mut self) {
        self.symbols.iter_mut().for_each(Symbol::darken);
    }

    fn set(&mut self, row: usize, char: char) {
        self.symbols[row].set(char);
    }
}

/// Current position of a _falling symbol_
struct Droplet {
    /// For the start of the animation we want to be able to place the symbol _above_ the screen,
    /// that's we need negative row values as well.
    row: isize,
    col: usize,
}

impl Droplet {
    /// create a new Droplet at a random location somewhere above the actual screen
    fn new_random(rng: &mut ThreadRng, width: usize, height: usize) -> Self {
        // the height of the terminal is expected lie within a sane range of this type
        #[allow(clippy::cast_possible_wrap)]
        Self {
            row: -(rng.gen_range(0..height) as isize),
            col: rng.gen_range(0..width),
        }
    }

    /// move the droplet down by one row
    /// if it hits the bottom row, move it back up to a random column
    fn update(&mut self, width: usize, height: usize) {
        self.row += 1;
        // the height of the terminal is expected lie within a sane range of this type
        #[allow(clippy::cast_possible_wrap)]
        if self.row >= height as isize {
            let mut rng = thread_rng();
            self.col = rng.gen_range(0..width);
            self.row = 0;
        }
    }
}

/// The entire screen filled with colored symbols
struct Screen {
    width: usize,
    height: usize,
    columns: Vec<Column>,
    droplets: Vec<Droplet>,
}

impl Screen {

    /// create a new empty screen with the given dimensions
    fn new(width: usize, height: usize) -> Self {
        let mut rng = thread_rng();
        Self {
            width,
            height,
            columns: repeat(Column::new(height)).take(width).collect(),
            droplets: (0..width).map(|_| Droplet::new_random(&mut rng, width, height)).collect(),
        }
    }

    /// print the entire screen to the terminal
    fn print<W: Write>(&self, out: &mut W) {
        for row in 0..self.height {
            for column in &self.columns {
                column.print_symbol(out, row);
            }
            write!(out, "\r\n").unwrap();
        }
    }

    // make all droplets fall down by one row
    fn update_droplets(&mut self) {
        let mut rng = thread_rng();
        for droplet in &mut self.droplets {
            droplet.update(self.width, self.height);
            if let Ok(row) = droplet.row.try_into() {
                let ch = CHARS.choose(&mut rng).copied().unwrap_or(' ');
                self.columns[droplet.col].set(row, ch);
            }
        }
    }

    // reduce the brightness of all symbols in this screen
    fn darken(&mut self) {
        self.columns.iter_mut().for_each(Column::darken);
    }

}

fn main() {
    // create the screen with the terminal's dimensions (omit the last row to prevent auto-scrolling)
    let (width, height) = termion::terminal_size().unwrap();
    let mut screen = Screen::new(width as usize, height as usize - 1);

    // create a channel which allows to send stuff between thread boundaries
    let (tx, rx) = channel();

    // spawn a new thread which will blockingly wait for a key to be pressed
    thread::spawn(move || {
        stdin().keys().next();
        // send something down the channel to notify the main thread that a key has been pressed
        tx.send(()).expect("Could not send signal on channel.");
    });

    // get write access to the terminal
    let mut stdout = stdout().into_raw_mode().unwrap();

    // clear the screen and hide the cursor
    write!(stdout, "{}{}", termion::clear::All, termion::cursor::Hide).unwrap();

    // continue while no key has been pressed (i.e. the notification channel is empty)
    while rx.try_recv() == Err(TryRecvError::Empty) {
        // move cursor to the top left and set background color to black
        write!(stdout, "{}{}", termion::cursor::Goto(1, 1), termion::color::Bg(termion::color::Rgb(0, 0, 0))).unwrap();

        // screen update
        screen.print(&mut stdout);
        screen.darken();
        screen.update_droplets();
        // make sure the terminal updates _now_
        stdout.flush().unwrap();

        // slow down animation
        std::thread::sleep(Duration::from_millis(50));
    }

    // reset Terminal back to normal
    write!(stdout, "{}", termion::style::Reset).unwrap();
    write!(stdout, "{}", termion::clear::All).unwrap();
    write!(stdout, "{}", termion::cursor::Goto(1, 1)).unwrap();
    write!(stdout, "{}", termion::cursor::Show).unwrap();
}
