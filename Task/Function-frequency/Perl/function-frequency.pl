use PPI::Tokenizer;
my $Tokenizer = PPI::Tokenizer->new( '/path/to/your/script.pl' );
my %counts;
while (my $token = $Tokenizer->get_token) {
    # We consider all Perl identifiers. The following regex is close enough.
    if ($token =~ /\A[\$\@\%*[:alpha:]]/) {
        $counts{$token}++;
    }
}
my @desc_by_occurrence =
    sort {$counts{$b} <=> $counts{$a} || $a cmp $b}
         keys(%counts);
my @top_ten_by_occurrence = @desc_by_occurrence[0 .. 9];
foreach my $token (@top_ten_by_occurrence) {
    print $counts{$token}, "\t", $token, "\n";
}
