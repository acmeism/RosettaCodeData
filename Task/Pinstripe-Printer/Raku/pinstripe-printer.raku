unit sub MAIN ($dpi = 300, $size = 'letter');

my $filename = './Pinstripe-printer-perl6.png';

my %paper = (
    'letter' => { :width(8.5),    :height(11.0) }
    'A4'     => { :width(8.2677), :height(11.6929)}
);

my ($w, $h) = %paper{$size}<width height> »*» $dpi;

# Black. It's all black
my @color = (0,0,0),;

my $gap = floor $w % ($dpi * 8) / 2;

my $rows = (1, * * 2 … * > 8 * $dpi).elems;

my $height = $dpi * .8;

use Cairo;

my @colors = @color.map: { Cairo::Pattern::Solid.new.create(|$_) };

given Cairo::Image.create(Cairo::FORMAT_ARGB32, $w, $h) -> $image {
    given Cairo::Context.new($image) {
        my Cairo::Pattern::Solid $bg .= create(1,1,1);
        .rectangle(0, 0, $w, $h);
        .pattern($bg);
        .fill;
        $bg.destroy;
        my $y = $gap;
        for ^$rows -> $row {
            my $x = $gap;
            my $width = 8 * $dpi / (2 ** $row);
            for @colors -> $this {
                my $v = 0;
                while $x < ($dpi * 8) {
                    given Cairo::Context.new($image) -> $block {
                        $block.rectangle($x, $y, $width, $height);
                        $block.pattern($this);
                        $block.fill;
                        $block.destroy;
                    }
                    $x += $width * 2;
                }
            }
            $y += $height;
        }
    }
    $image.write_png($filename);
}

# Uncomment next line if you actually want to print it
#run('lp', $filename)
