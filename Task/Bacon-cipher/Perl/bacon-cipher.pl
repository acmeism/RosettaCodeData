use strict;
use warnings;
use utf8;
binmode(STDOUT, ':utf8');

my $secret = <<'END';
This task is to implement a program for encryption and decryption
of plaintext using the simple alphabet of the Baconian cipher or
some other kind of representation of this alphabet (make anything
signify anything). This example will work with anything in the
ASCII range... even code! $r%_-^&*(){}+~ #=`/\';*1234567890"'
END

my $text = <<'END';
Bah. It isn't really practical to use typeface changes to encode
information, it is too easy to tell that there is something going
on and will attract attention. Font changes with enough regularity
to encode mesages relatively efficiently would need to happen so
often it would be obvious that there was some kind of manipulation
going on. Steganographic encryption where it is obvious that there
has been some tampering with the carrier is not going to be very
effective. Not that any of these implementations would hold up to
serious scrutiny anyway. Anyway, here's a semi-bogus implementation
that hides information in white space. The message is hidden in this
paragraph of text. Yes, really. It requires a fairly modern file
viewer to display (not display?) the hidden message, but that isn't
too unlikely any more. It may be stretching things to call this a
Bacon cipher, but I think it falls within the spirit of the task,
if not the exact definition.
END

my @enc = ("\N{U+FEFF}", "\N{U+200B}"); # zero-width spaces
my %dec;
$dec{$enc[0]} = 0;
$dec{$enc[1]} = 1;

sub encode { my($c) = @_; join '', @enc[split '', sprintf "%07b", ord($c)] }
sub hide {
    my($text, @msg) = @_;
    my $head = substr($text, 0, @msg);
    my $tail = substr($text, @msg);
    my @head = split '', $head;
    my $merge;
    while (@msg) { $merge .= shift(@head) . shift(@msg) }
    $merge . $tail;
}

sub reveal {
    my($steganography) = @_;
    my $message;
    (my $cleaned = $steganography) =~ s/\w|[,?:.!\-&*()*"']| |\n//g;
    for my $coded_char (split /(.{7})/, $cleaned) {
        next if length $coded_char == 0;
        my $bits = '';
        $bits .= $dec{$_} for split //, $coded_char;
        $message .= chr eval('0b'.$bits);
    }
    $message;
}
my @hidden = map  { encode($_) } split '', $secret;
my $steganography = hide($text, @hidden);
my $decoded       = reveal $steganography;

print "$steganography\n"
print "$decoded\n"
