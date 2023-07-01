use strict;
use warnings;
use Tk;

my $main = MainWindow->new;
$main->Button(
  -text => 'Goodbye, World',
  -command => \&exit,
)->pack;
MainLoop();
