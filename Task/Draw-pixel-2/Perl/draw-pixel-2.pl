use Gtk3 '-init';

my $width  = 640;
my $height = 480;

my $window = Gtk3::Window->new();
$window->set_default_size($width, $height);
$window->set_border_width(10);
$window->set_title("Draw Pixel 2");
$window->set_app_paintable(TRUE);

my $da = Gtk3::DrawingArea->new();
$da->signal_connect('draw' => \&draw_in_drawingarea);
$window->add($da);
$window->show_all();

Gtk3->main;

sub draw_in_drawingarea
{
  my ($widget, $cr, $data) = @_;
  $cr->set_source_rgb(1, 1, 0);
  $cr->set_line_width(1);
  $cr->rectangle( int rand $width , int rand $height, 1, 1);
  $cr->stroke;
}
