constant MAXINT = uint.Range.max;
constant BITS = MAXINT.base(2).chars;

# define rotate ops for the fun of it
multi sub infix:<⥁>(Int:D \a, Int:D \b) { :2[(a +& MAXINT).polymod(2 xx BITS-1).list.rotate(b).reverse] }
multi sub infix:<⥀>(Int:D \a, Int:D \b) { :2[(a +& MAXINT).polymod(2 xx BITS-1).reverse.rotate(b)] }

sub int-bits (Int $a, Int $b) {
    say '';
    say_bit "$a", $a;
    say '';
    say_bit "2's complement $a", +^$a;
    say_bit "$a and $b", $a +& $b;
    say_bit "$a or $b",  $a +| $b;
    say_bit "$a xor $b", $a +^ $b;
    say_bit "$a unsigned shift right $b", ($a +& MAXINT) +> $b;
    say_bit "$a signed shift right $b", $a +> $b;
    say_bit "$a rotate right $b", $a ⥁ $b;
    say_bit "$a shift left $b", $a +< $b;
    say_bit "$a rotate left $b", $a ⥀ $b;
}

int-bits(7,2);
int-bits(-65432,31);

sub say_bit ($message, $value) {
    printf("%30s: %{'0' ~ BITS}b\n", $message, $value +& MAXINT);
}
