use strict;
use warnings;
use Tk;

my $main = MainWindow->new;
$main->Label(-text => 'Goodbye, World')->pack;
MainLoop();
