require 'gtk2'

window = Gtk::Window.new
window.title = 'Goodbye, World'
window.signal_connect(:delete-event) { Gtk.main_quit }
window.show_all

Gtk.main
