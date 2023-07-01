my $src = 'unixdict.txt';

# filter word-file for valid input, transform to low-case
open $fh, "<", $src;
@words = grep { /^[a-zA-Z]+$/ } <$fh>;
map { tr/A-Z/a-z/ } @words;

# translate words to dials
map { tr/abcdefghijklmnopqrstuvwxyz/22233344455566677778889999/ } @dials = @words;

# get unique values (modify @dials) and non-unique ones (are textonyms)
@dials = grep {!$h{$_}++} @dials;
@textonyms = grep { $h{$_} > 1 } @dials;

print "There are @{[scalar @words]} words in '$src' which can be represented by the digit key mapping.
They require @{[scalar @dials]} digit combinations to represent them.
@{[scalar @textonyms]} digit combinations represent Textonyms.";
