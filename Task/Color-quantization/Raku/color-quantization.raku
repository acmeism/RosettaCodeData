use MagickWand;
use MagickWand::Enums;

my $frog = MagickWand.new;
$frog.read("./Quantum_frog.png");
$frog.quantize(16, RGBColorspace, 0, True, False);
$frog.write('./Quantum-frog-16-perl6.png');
