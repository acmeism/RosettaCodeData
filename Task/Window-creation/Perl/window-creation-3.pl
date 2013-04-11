  use Gtk '-init';

  $window = Gtk::Window->new;
  $window->signal_connect(
    destroy => sub { Gtk->main_quit; }
  );
  $window->show_all;
  Gtk->main;
