unit sub MAIN ($in is copy = '', :$dict = 'unixdict.txt');

say 'Enter a word or phrase to be anagramed. (Loading dictionary)' unless $in.chars;

# Load the words into a word / Bag hash
my %words = $dict.IO.slurp.lc.words.race.map: { .comb(/\w/).join => .comb(/\w/).Bag };

# Declare some globals
my ($phrase, $count, $bag);

loop {
    ($phrase, $count, $bag) = get-phrase;
    find-anagram Hash.new: %words.grep: { .value ⊆ $bag };
}

sub get-phrase {
    my $prompt = $in.chars ?? $in !! prompt "\nword or phrase? (press Enter to quit) ";
    $in = '';
    exit unless $prompt;
    $prompt,
    +$prompt.comb(/\w/),
    $prompt.lc.comb(/\w/).Bag;
}

sub find-anagram (%subset, $phrase is copy = '', $last = Inf) {
    my $remain = $bag ∖ $phrase.comb(/\w/).Bag;        # Find the remaining letters
    my %filtered = %subset.grep: { .value ⊆ $remain }; # Find words using the remaining letters
    my $sofar = +$phrase.comb(/\w/);                   # Get the count of the letters used so far
    for %filtered.sort: { -.key.chars, ~.key } {       # Sort by length then alphabetically then iterate
        my $maybe = +.key.comb(/\w/);                  # Get the letter count of the maybe addition
        next if $maybe > $last;                        # Next if it is longer than last - only consider descending length words
        next if $maybe == 1 and $last == 1;            # Only allow one one character word
        next if $count - $sofar - $maybe > $maybe;     # Try to balance word lengths
        if $sofar + $maybe == $count {                 # It's an anagram
            say $phrase ~ ' ' ~ .key and next;         # Display it and move on
        } else {                                       # Not yet a full anagram, recurse
            find-anagram %filtered, $phrase ~ ' ' ~ .key, $maybe;
        }
    }
}
