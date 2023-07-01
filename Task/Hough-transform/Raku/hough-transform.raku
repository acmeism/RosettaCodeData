use GD;

my $filename = 'pentagon.ppm';
my $in = open($filename, :r, :enc<iso-8859-1>);
my ($type, $dim, $depth) = $in.lines[^3];
my ($xsize,$ysize) = split ' ', $dim;

my ($width, $height) = 460, 360;
my $image = GD::Image.new($width, $height);

my @canvas = [255 xx $width] xx $height;

my $rmax = sqrt($xsize**2 + $ysize**2);
my $dr   = 2 * $rmax / $height;
my $dth  = π / $width;

my $pixel = 0;
my %cstore;
for $in.lines.ords -> $r, $g, $b {
    $pixel++;
    next if $r > 130;

    my $x =       $pixel % $xsize;
    my $y = floor $pixel / $xsize;

    (^$width).map: -> $k {
        my $th = $dth*$k;
        my $r = ($x*cos($th) + $y*sin($th));
        my $iry = ($height/2 + ($r/$dr).round(1)).Int;
        my $c = '#' ~ (@canvas[$iry][$k]--).base(16) x 3;
        %cstore{$c} = $image.colorAllocate($c) if %cstore{$c}:!exists;
        $image.pixel($k, $iry, %cstore{$c});
    }
}

my $png_fh = $image.open("hough-transform.png", "wb");
$image.output($png_fh, GD_PNG);
$png_fh.close;
