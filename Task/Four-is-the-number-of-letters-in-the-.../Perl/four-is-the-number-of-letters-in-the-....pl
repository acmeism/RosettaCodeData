use feature 'state';
use Lingua::EN::Numbers qw(num2en num2en_ordinal);

my @sentence = split / /, 'Four is the number of letters in the first word of this sentence, ';

sub extend_to {
    my($last) = @_;
    state $index = 1;
    until ($#sentence > $last) {
        push @sentence, split ' ', num2en(alpha($sentence[$index])) . ' in the ' . no_c(num2en_ordinal(1+$index)) . ',';
        $index++;
    }
}

sub alpha { my($s) = @_; $s =~ s/\W//gi; length $s }
sub no_c  { my($s) = @_; $s =~ s/\ and|,//g;   return $s }
sub count { length(join ' ', @sentence[0..-1+$_[0]]) . " characters in the sentence, up to and including this word.\n" }

print "First 201 word lengths in the sequence:\n";
extend_to(201);
for (0..200) {
    printf "%3d", alpha($sentence[$_]);
    print "\n" unless ($_+1) % 32;
}
print "\n" . count(201) . "\n";

for (1e3, 1e4, 1e5, 1e6, 1e7) {
    extend_to($_);
    print
        ucfirst(num2en_ordinal($_)) .  " word, '$sentence[$_-1]' has " . alpha($sentence[$_-1]) .  " characters. \n" .
        count($_) . "\n";
}
