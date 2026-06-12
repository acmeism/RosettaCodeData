use strict;
use warnings;
use Class::Struct;
use Cairo;

{ package Line;
    struct( A => '@', B => '@');
}

my ($WIDTH,  $HEIGHT,  $W_LINE,  $CURVE_F,  $DETACHED,            $OUTPUT  ) =
   (   400,      400,        2,      0.25,          0,  'run/b-spline.png' );

my @pt = (
   [171, 171], [185, 111], [202, 109], [202, 189], [328, 160], [208, 254],
   [241, 330], [164, 252], [ 69, 278], [139, 208], [ 72, 148], [168, 172]
);
my $cnt = @pt;

sub angle {
    my($g) = @_;
    atan2 $g->B->[1] - $g->A->[1], $g->B->[0] - $g->A->[0]
}

sub control_points {
    my($g, $l) = @_;

    my $h = Line->new;
    my $lgt = sqrt( ($g->B->[0] - $l->A->[0])**2 + ($g->B->[1] - $l->A->[1])**2 );

    @{$h->B} = @{$l->A};
    @{$h->A} = ($g->B->[0] - $lgt * cos(angle $g) , $g->B->[1] - $lgt * sin(angle $g));
    my $a    = angle $h;
    my @p1   = ($g->B->[0] + $lgt * cos($a) * $CURVE_F,  $g->B->[1] + $lgt * sin($a) * $CURVE_F);

    @{$h->A} = @{$g->B};
    @{$h->B} = ($l->A->[0] + $lgt * cos(angle $l) , $l->A->[1] + $lgt * sin(angle $l));
    $a       = angle $h;
    my @p2   = ($l->A->[0] - $lgt * cos($a) * $CURVE_F,  $l->A->[1] - $lgt * sin($a) * $CURVE_F);

    \@p1, \@p2
}

my $surf = Cairo::ImageSurface->create ('argb32', $WIDTH, $HEIGHT);
my $cr   = Cairo::Context->create ($surf);
$cr->set_line_width($W_LINE);
$cr->move_to($pt[$DETACHED - 1 + $cnt][0], $pt[$DETACHED - 1 + $cnt][1]);

my Line ($g,$l);
for my $j ($DETACHED..$cnt-1) {
    $g = Line->new( A=>$pt[($j + $cnt - 2) % $cnt], B=>$pt[($j + $cnt - 1) % $cnt]);
    $l = Line->new( A=>$pt[($j + $cnt + 0) % $cnt], B=>$pt[($j + $cnt + 1) % $cnt]);
    my($p1,$p2) = control_points($g, $l);
    $cr->curve_to($$p1[0], $$p1[1], $$p2[0], $$p2[1], $pt[$j][0], $pt[$j][1]);
}
$cr->stroke;
$surf->write_to_png($OUTPUT);
