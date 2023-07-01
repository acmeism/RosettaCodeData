sub intersection ($L11, $L12, $L21, $L22) {
    my ($Δ1x, $Δ1y) = $L11 »-« $L12;
    my ($Δ2x, $Δ2y) = $L21 »-« $L22;
    my $n1 = $L11[0] * $L12[1] - $L11[1] * $L12[0];
    my $n2 = $L21[0] * $L22[1] - $L21[1] * $L22[0];
    my $n3 = 1 / ($Δ1x * $Δ2y - $Δ2x * $Δ1y);
    (($n1 * $Δ2x - $n2 * $Δ1x) * $n3, ($n1 * $Δ2y - $n2 * $Δ1y) * $n3)
}


sub is-inside ($p1, $p2, $p3) {
    ($p2[0] - $p1[0]) * ($p3[1] - $p1[1]) > ($p2[1] - $p1[1]) * ($p3[0] - $p1[0])
}

sub sutherland-hodgman (@polygon, @clip) {
    my @output = @polygon;
    my $clip-point1 = @clip.tail;
    for @clip -> $clip-point2 {
        my @input = @output;
        @output = ();
        my $start = @input.tail;
        for @input -> $end {
            if is-inside($clip-point1, $clip-point2, $end) {
                @output.push: intersection($clip-point1, $clip-point2, $start, $end)
                  unless is-inside($clip-point1, $clip-point2, $start);
                @output.push: $end;
            } elsif is-inside($clip-point1, $clip-point2, $start) {
                @output.push: intersection($clip-point1, $clip-point2, $start, $end);
            }
            $start = $end;
        }
        $clip-point1 = $clip-point2;
    }
    @output
}

my @polygon = (50,  150), (200, 50),  (350, 150), (350, 300), (250, 300),
              (200, 250), (150, 350), (100, 250), (100, 200);

my @clip    = (100, 100), (300, 100), (300, 300), (100, 300);

my @clipped = sutherland-hodgman(@polygon, @clip);

say "Clipped polygon: ", @clipped;

# Output an SVG as well as it is easier to visualize
use SVG;
my $outfile = 'Sutherland-Hodgman-polygon-clipping-perl6.svg'.IO.open(:w);
$outfile.say: SVG.serialize(
    svg => [
        :400width, :400height,
        :rect[ :400width, :400height, :fill<white> ],
        :text[ :10x, :20y, "Polygon (blue)" ],
        :text[ :10x, :35y, "Clip port (green)" ],
        :text[ :10x, :50y, "Clipped polygon (red)" ],
        :polyline[ :points(@polygon.join: ','), :style<stroke:blue>,  :fill<blue>,  :opacity<.3> ],
        :polyline[ :points(   @clip.join: ','), :style<stroke:green>, :fill<green>, :opacity<.3> ],
        :polyline[ :points(@clipped.join: ','), :style<stroke:red>,   :fill<red>,   :opacity<.5> ],
    ],
);
