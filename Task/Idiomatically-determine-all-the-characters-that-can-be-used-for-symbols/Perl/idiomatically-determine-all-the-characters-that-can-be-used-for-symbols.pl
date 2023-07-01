# When not using the <code>use utf8</code> pragma, any word character in the ASCII range is allowed.
# the loop below returns: 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz
for $i (0..0x7f) {
    $c = chr($i);
    print $c if $c =~ /\w/;
}

# When 'use utf8' is in force, the same holds true, but the Unicode-aware version of the 'word-character' test is used.
# not supplying output, too much of it
use utf8;
binmode STDOUT, ":utf8";
for (0..0x1ffff) {
    $c = chr($_);
    print $c if $c =~ /\p{Word}/;
}
