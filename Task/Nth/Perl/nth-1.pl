my %irregulars = ( 1 => 'st',
                   2 => 'nd',
                   3 => 'rd',
                  11 => 'th',
                  12 => 'th',
                  13 => 'th');
sub nth
{
    my $n = shift;
    $n . # q(') . # Uncomment this to add apostrophes to output
    ($irregulars{$n % 100} // $irregulars{$n % 10} // 'th');
}

sub range { join ' ', map { nth($_) } @{$_[0]} }
print range($_), "\n" for ([0..25], [250..265], [1000..1025]);
