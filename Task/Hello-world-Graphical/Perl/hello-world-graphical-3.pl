use strict;
use warnings;
use Gtk2 '-init';

my $window = Gtk2::Window->new;
$window->set_title('Goodbye world');
$window->signal_connect(
  destroy => sub { Gtk2->main_quit; }
);

my $label = Gtk2::Label->new('Goodbye, world');
$window->add($label);

$window->show_all;
Gtk2->main;
