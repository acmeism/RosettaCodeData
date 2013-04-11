  use Gtk2 '-init';

  $window = Gtk2::Window->new;
  $window->signal_connect(
    destroy => sub { Gtk2->main_quit; }
  );
  $window->show_all;
  Gtk2->main;
