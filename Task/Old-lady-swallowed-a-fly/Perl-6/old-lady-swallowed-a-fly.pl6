my @victims =
    fly    => "  I don't know why S—",
    spider => "  That wriggled and jiggled and tickled inside her.",
    bird   => "  How absurd, T!",
    cat    => "  Fancy that, S!",
    dog    => "  What a hog, T!",
    goat   => "  She just opened her throat, and in walked the goat!",
    cow    => "  I don't know how S!",
    horse  => "  She's dead, of course...";

my @history = "I guess she'll die...\n";

for (flat @victims».kv) -> $victim, $_ is copy {
    say "There was an old lady who swallowed a $victim...";

    s/ «S» /she swallowed the $victim/;
    s/ «T» /to swallow a $victim!/;
    .say;
    last when /dead/;

    @history[0] ~~ s/^X/She swallowed the $victim/;
    .say for @history;
    @history.unshift($_) if @history < 5;
    @history.unshift("X to catch the $victim,");
}
