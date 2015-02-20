use strict;
use warnings;
use QtGui4;

my $app = Qt::Application(\@ARGV);
my $label = Qt::Label('Goodbye, World');
$label->show;
exit $app->exec;
