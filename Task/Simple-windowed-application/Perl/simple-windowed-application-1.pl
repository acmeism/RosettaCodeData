use Tk;

$main = MainWindow->new;
$l = $main->Label('-text' => 'There have been no clicks yet.')->pack;
$count = 0;
$main->Button(
  -text => ' Click Me ',
  -command => sub { $l->configure(-text => 'Number of clicks: '.(++$count).'.'); },
)->pack;
MainLoop();
