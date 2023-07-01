use strict;
use warnings;
use QtGui4;

my $app = Qt::Application(\@ARGV);
my $window = Qt::MainWindow;
$window->show;
exit $app->exec;
