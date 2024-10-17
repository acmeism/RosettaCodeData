/* Uses C library interface */

extern crate libc;

fn main() {
    let istty = unsafe { libc::isatty(libc::STDIN_FILENO as i32) } != 0;
    if istty {
        println!("stdout is tty");
    } else {
        println!("stdout is not tty");
    }
}
