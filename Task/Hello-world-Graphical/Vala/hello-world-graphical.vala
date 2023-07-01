#!/usr/local/bin/vala --pkg gtk+-3.0
using Gtk;

void main(string[] args) {
    Gtk.init(ref args);

    var window = new Window();
    window.title = "Goodbye, world!";
    window.border_width = 10;
    window.window_position = WindowPosition.CENTER;
    window.set_default_size(350, 70);
    window.destroy.connect(Gtk.main_quit);

    var label = new Label("Goodbye, world!");

    window.add(label);
    window.show_all();

    Gtk.main();
}
