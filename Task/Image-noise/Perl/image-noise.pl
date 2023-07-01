use Gtk3 '-init';
use Glib qw/TRUE FALSE/;
use Time::HiRes qw/ tv_interval gettimeofday/;

my $time0 = [gettimeofday];
my $frames = -8; # account for set-up steps before drawing

my $window = Gtk3::Window->new();
$window->set_default_size(320, 240);
$window->set_border_width(0);
$window->set_title("Image_noise");
$window->set_app_paintable(TRUE);

my $da = Gtk3::DrawingArea->new();
$da->signal_connect('draw' => \&draw_in_drawingarea);
$window->add($da);
$window->show_all();
Glib::Timeout->add (1, \&update);

Gtk3->main;

sub draw_in_drawingarea {
  my ($widget, $cr, $data) = @_;
  $cr->set_line_width(1);
  for $x (1..320) {
    for $y (1..240) {
      int rand 2 ? $cr->set_source_rgb(0, 0, 0) : $cr->set_source_rgb(1, 1, 1);
      $cr->rectangle( $x, $y, 1, 1);
      $cr->stroke;
    }
  }
}

sub update {
    $da->queue_draw;
    my $elapsed = tv_interval( $time0, [gettimeofday] );
    $frames++;
    printf "fps: %.1f\n", $frames/$elapsed if $frames > 5;
    return TRUE;
}
