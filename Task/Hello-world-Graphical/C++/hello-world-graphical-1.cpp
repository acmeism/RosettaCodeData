#include <gtkmm.h>
int main(int argc, char *argv[])
{
   Gtk::Main app(argc, argv);
   Gtk::MessageDialog msg("Goodbye, World!");
   msg.run();
}
