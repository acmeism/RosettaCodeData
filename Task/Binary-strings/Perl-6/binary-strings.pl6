# Perl 6 is perfectly fine with NUL *characters* in strings:
my Str $s = 'nema' ~ 0.chr ~ 'problema!';
say $s;

# However, Perl 6 makes a clear distinction between strings
# (i.e. sequences of characters), like your name, or …
my Str $str = "My God, it's full of chars!";
# … and sequences of bytes (called Bufs), for example a PNG image, or …
my Buf $buf = Buf.new(255, 0, 1, 2, 3);
say $buf;

# Strs can be encoded into Blobs …
my Blob $this = 'round-trip'.encode('ascii');
# … and Blobs can be decoded into Strs …
my Str $that = $this.decode('ascii');

# So it's all there. Nevertheless, let's solve this task explicitly
# in order to see some nice language features:

# We define a class …
class ByteStr {
    # … that keeps an array of bytes, and we delegate some
    # straight-forward stuff directly to this attribute:
    # (Note: "has byte @.bytes" would be nicer, but that is
    # not yet implemented in Rakudo.)
    has Int @.bytes handles(< Bool elems gist push >);

    # A handful of methods …
    method clone() {
        self.new(:@.bytes);
    }

    method substr(Int $pos, Int $length) {
        self.new(:bytes(@.bytes[$pos .. $pos + $length - 1]));
    }

    method replace(*@substitutions) {
        my %h = @substitutions;
        @.bytes.=map: { %h{$_} // $_ }
    }
}

# A couple of operators for our new type:
multi infix:<cmp>(ByteStr $x, ByteStr $y) { $x.bytes.join cmp $y.bytes.join }
multi infix:<~>  (ByteStr $x, ByteStr $y) { ByteStr.new(:bytes(|$x.bytes, |$y.bytes)) }

# create some byte strings (destruction not needed due to garbage collection)
my ByteStr $b0 = ByteStr.new;
my ByteStr $b1 = ByteStr.new(:bytes( |'foo'.ords, 0, 10, |'bar'.ords ));

# assignment ($b1 and $b2 contain the same ByteStr object afterwards):
my ByteStr $b2 = $b1;

# comparing:
say 'b0 cmp b1 = ', $b0 cmp $b1;
say 'b1 cmp b2 = ', $b1 cmp $b2;

# cloning:
my $clone = $b1.clone;
$b1.replace('o'.ord => 0);
say 'b1 = ', $b1;
say 'b2 = ', $b2;
say 'clone = ', $clone;

# to check for (non-)emptiness we evaluate the ByteStr in boolean context:
say 'b0 is ', $b0 ?? 'not empty' !! 'empty';
say 'b1 is ', $b1 ?? 'not empty' !! 'empty';

# appending a byte:
$b1.push: 123;
say 'appended = ', $b1;

# extracting a substring:
my $sub = $b1.substr(2, 4);
say 'substr = ', $sub;

# replacing a byte:
$b2.replace(102 => 103);
say 'replaced = ', $b2;

# joining:
my ByteStr $b3 = $b1 ~ $sub;
say 'joined = ', $b3;
