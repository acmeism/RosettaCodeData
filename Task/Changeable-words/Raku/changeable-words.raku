use Text::Levenshtein;
use Text::Sorensen :sorensen;

my @words = grep {.chars > 11}, 'unixdict.txt'.IO.words;

my %bi-grams = @words.map: { $_ => .&bi-gram };

my %skip = @words.map: { $_ => 0 };

say (++$).fmt('%2d'), |$_ for @words.hyper.map: -> $this {
    next if %skip{$this};
    my ($word, @sorensens) = sorensen($this, %bi-grams);
    next unless @sorensens.=grep: { 1 > .[0] > .8 };
    @sorensens = @sorensens»[1].grep: {$this.chars == .chars};
    my @levenshtein = distance($this, @sorensens).grep: * == 1, :k;
    next unless +@levenshtein;
    %skip{$_}++ for @sorensens[@levenshtein];
    ": {$this.fmt('%14s')}  <->  ", @sorensens[@levenshtein].join: ', ';
}
