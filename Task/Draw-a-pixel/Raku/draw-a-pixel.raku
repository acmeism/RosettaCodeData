use GTK::Simple;
use GTK::Simple::DrawingArea;
use Cairo;

my $app = GTK::Simple::App.new(:title('Draw a Pixel'));
my $da  = GTK::Simple::DrawingArea.new;
gtk_simple_use_cairo;

$app.set-content( $da );
$app.border-width = 5;
$da.size-request(320,240);

sub rect-do( $d, $ctx ) {
    given $ctx {
        .rgb(1, 0, 0);
        .rectangle(100, 100, 1, 1);
        .fill;
    }
}

my $ctx = $da.add-draw-handler( &rect-do );
$app.run;
