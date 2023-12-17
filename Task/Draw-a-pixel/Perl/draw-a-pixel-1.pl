use Gtk3 '-init';

my $window = Gtk3::Window->new();
$window->set_default_size(320, 240);
$window->set_border_width(10);
$window->set_title("Draw a Pixel");
$window->set_app_paintable(TRUE);

my $da = Gtk3::DrawingArea->new();
$da->signal_connect('draw' => \&draw_in_drawingarea);
$window->add($da);
$window->show_all();

Gtk3->main;

sub draw_in_drawingarea
{
  my ($widget, $cr, $data) = @_;
  $cr->set_source_rgb(1, 0, 0);
  $cr->set_line_width(1);
  $cr->rectangle( 100, 100, 1, 1);
  $cr->stroke;
}
