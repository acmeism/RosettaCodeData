use Lingua::EN::Numbers;
use Base::Any;

sub rf (int $base = 10, $batch = Any, &op = &infix:<==>) {
    my %batch = batch => $batch if $batch;
    flat (1 .. ∞).hyper(|%batch).map: {
        my int ($this, $last) = $_, $_ % $base;
        my int ($rise, $fall) = 0, 0;
        while $this {
            my int $rem = $this % $base;
            $this = $this div $base;
            if    $rem > $last { $fall = $fall + 1 }
            elsif $rem < $last { $rise = $rise + 1 }
            $last = $rem
        }
        next unless &op($rise, $fall);
        $_
    }
}

# The task
my $upto = 200;
put "Rise = Fall:\nFirst {$upto.&cardinal} (base 10):";
.put for rf[^$upto]».fmt("%3d").batch(20);

$upto = 10_000_000;
put "\nThe {$upto.&ordinal} (base 10): ", comma rf(10, 65536)[$upto - 1];

# Other bases and comparisons
put "\n\nGeneralized for other bases and other comparisons:";
$upto = ^5;
my $which = "{tc $upto.map({.exp(10).&ordinal}).join: ', '}, values in some other bases:";

put "\nRise = Fall: $which";
for <3 296691 4 296694 5 296697 6 296700 7 296703 8 296706 9 296709 10 296712
     11 296744 12 296747 13 296750 14 296753 15 296756 16 296759 20 296762 60 296765>
  -> $base, $oeis {
    put "Base {$base.fmt(<%2d>)} (https://oeis.org/A$oeis): ",
    $upto.map({rf(+$base, Any)[.exp(10) - 1].&to-base($base)}).join: ', '
}

put "\nRise > Fall: $which";
for <3 296692 4 296695 5 296698 6 296701 7 296704 8 296707 9 296710 10 296713
     11 296745 12 296748 13 296751 14 296754 15 296757 16 296760 20 296763 60 296766>
  -> $base, $oeis {
     put "Base {$base.fmt(<%2d>)} (https://oeis.org/A$oeis): ",
     $upto.map({rf(+$base, Any, &infix:«>»)[.exp(10) - 1].&to-base($base)}).join: ', '
 }

put "\nRise < Fall: $which";
for <3 296693 4 296696 5 296699 6 296702 7 296705 8 296708 9 296711 10 296714
     11 296746 12 296749 13 296752 14 296755 15 296758 16 296761 20 296764 60 296767>
  -> $base, $oeis {
     put "Base {$base.fmt(<%2d>)} (https://oeis.org/A$oeis): ",
     $upto.map({rf(+$base, Any, &infix:«<»)[.exp(10) - 1].&to-base($base)}).join: ', '
 }
