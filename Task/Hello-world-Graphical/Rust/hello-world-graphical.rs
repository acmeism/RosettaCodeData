// cargo-deps:  gtk
extern crate gtk;
use gtk::traits::*;
use gtk::{Window, WindowType, WindowPosition};
use gtk::signal::Inhibit;

fn main() {
    gtk::init().unwrap();
    let window = Window::new(WindowType::Toplevel).unwrap();

    window.set_title("Goodbye, World!");
    window.set_border_width(10);
    window.set_window_position(WindowPosition::Center);
    window.set_default_size(350, 70);
    window.connect_delete_event(|_,_| {
        gtk::main_quit();
        Inhibit(false)
    });

    window.show_all();
    gtk::main();
}
