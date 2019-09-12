use Tk;
use Time::HiRes qw(sleep);

my $msg    = 'Hello World! ';
my $first  = '.+';
my $second = '.';

my $mw = Tk::MainWindow->new(-title => 'Animated side-scroller',-bg=>"white");
$mw->geometry ("400x150+0+0");

$mw->optionAdd('*Label.font', 'Courier 24 bold' );

my $scroller = $mw->Label(-text => "$msg")->grid(-row=>0,-column=>0);
$mw->bind('all'=> '<Key-Escape>' => sub {exit;});
$mw->bind("<Button>" => sub { ($second,$first) = ($first,$second) });

$scroller->after(1, \&display );
MainLoop;

sub display {
    while () {
        sleep 0.25;
        $msg =~ s/($first)($second)/$2$1/;
        $scroller->configure(-text=>"$msg");
        $mw->update();
    }
}
