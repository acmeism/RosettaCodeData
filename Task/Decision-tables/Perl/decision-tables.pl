use v5.36;

sub decide($q,$a) {
    my @q = @{$q};
    my %a = %{$a};
    my($cnt,$bit) = (1,0);

    for my $prompt (@q) {
        print "$prompt: ";
        $bit += $cnt if <> =~ /y/i;
        $cnt *= 2;
    }
    $bit = 2**$bit;

    while (my ($bitpat,$diagnosis) = each %a) {
        print "$diagnosis\n" if $bit & $bitpat;
    }
}

my @queries = (
    'Printer is unrecognised',
    'A red light is flashing',
    'Printer does not print',
);

my %answers = (
    0b00100000 => 'Check the power cable',
    0b10100000 => 'Check the printer-computer cable',
    0b10101010 => 'Ensure printer software is installed',
    0b11001100 => 'Check/replace ink',
    0b01010000 => 'Check for paper jam',
);

decide(\@queries,\%answers);
