use GTK::Simple;
use GTK::Simple::App;

my $app    = GTK::Simple::App.new(:title<Animation>);
my $button = GTK::Simple::Button.new(label => 'Hello World! ');
my $vbox   = GTK::Simple::VBox.new($button);

my $repeat = $app.g-timeout(100); # milliseconds

my $dir = 1;
$button.clicked.tap({ $dir *= -1 });

$repeat.tap( &{$button.label = $button.label.comb.List.rotate($dir).join} );

$app.set-content($vbox);

$app.run;
