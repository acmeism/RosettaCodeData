use v5.36;

sub U ($n) { $n>1 ? (2*$n)**2 : 1 }
sub L ($n) { $n**2 }
sub R ($n) { 1 x $n }

my($l,$u,$c) = (-1);

while (++$u) {
    next if U($u) =~ /0/;
    my $chars = length U($u);
    while ($l++) {
        next if U($u) - L($l) > R($chars);
        last if U($u) - L($l) < R($chars);
        say U($u) and ++$c == 7 and exit
    }
}
