my @d = [^10] xx 5;
@d[$_][^5].=rotate($_), @d[$_][5..*].=rotate($_) for 1..4;
push @d: [@d[$_].reverse] for flat 1..4, 0;

my @i = 0,4,3,2,1,5,6,7,8,9;

my %h = flat (0,1,5,8,9,4,2,7,0).rotor(2 =>-1).map({.[0]=>.[1]}), 6=>3, 3=>6;
my @p = [^10],;
@p.push: [@p[*-1].map: {%h{$_}}] for ^7;

sub checksum (Int $int where * ≥ 0, :$verbose = True ) {
    my @digits = $int.comb;
    say "\nCheckdigit calculation for $int:";
    say " i  ni  p(i, ni)  c" if $verbose;
    my ($i, $p, $c) = 0 xx 3;
    say " $i   0      $p     $c" if $verbose;
    for @digits.reverse {
        ++$i;
        $p = @p[$i % 8][$_];
        $c = @d[$c; $p];
        say "{$i.fmt('%2d')}   $_      $p     $c" if $verbose;
    }
    say "Checkdigit: {@i[$c]}";
    +($int ~ @i[$c]);
}

sub validate (Int $int where * ≥ 0, :$verbose = True) {
    my @digits = $int.comb;
    say "\nValidation calculation for $int:";
    say " i  ni  p(i, ni)  c" if $verbose;
    my ($i, $p, $c) = 0 xx 3;
    for @digits.reverse {
        $p = @p[$i % 8][$_];
        $c = @d[$c; $p];
        say "{$i.fmt('%2d')}   $_      $p     $c" if $verbose;
        ++$i;
    }
    say "Checkdigit: {'in' if $c}correct";
}

## TESTING

for 236, 12345, 123456789012 -> $int {
    my $check = checksum $int, :verbose( $int.chars < 8 );
    validate $check, :verbose( $int.chars < 8 );
    validate +($check.chop ~ 9), :verbose( $int.chars < 8 );
}
