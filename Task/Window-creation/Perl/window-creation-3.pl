  use Gtk3 '-init';

  $window = Gtk3::Window->new;
  $window->signal_connect(
    destroy => sub { Gtk3->main_quit; }
  );
  $window->show_all;
  Gtk3->main;
