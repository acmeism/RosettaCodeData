use Lingua::EN::Numbers;
no-commas(True);

my $index = 1;
my @sentence = flat 'Four is the number of letters in the first word of this sentence, '.words,
  { @sentence[$index++].&alpha.&cardinal, 'in', 'the', |($index.&ordinal ~ ',').words } ... * ;

sub alpha ( $str ) { $str.subst(/\W/, '', :g).chars }
sub count ( $index ) { @sentence[^$index].join(' ').chars ~ " characters in the sentence, up to and including this word.\n" }

say 'First 201 word lengths in the sequence:';
put ' ', map { @sentence[$_].&alpha.fmt("%2d") ~ (((1+$_) %% 25) ?? "\n" !! '') }, ^201;
say 201.&count;

for 1e3, 1e4, 1e5, 1e6, 1e7 {
    say "{.&ordinal.tc} word, '{@sentence[$_ - 1]}', has {@sentence[$_ - 1].&alpha} characters. ", .&count
}
