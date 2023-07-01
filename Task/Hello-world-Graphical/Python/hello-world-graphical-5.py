import pygtk
pygtk.require('2.0')
import gtk

window = gtk.Window()
window.set_title('Goodbye, World')
window.connect('delete-event', gtk.main_quit)
window.show_all()
gtk.main()
