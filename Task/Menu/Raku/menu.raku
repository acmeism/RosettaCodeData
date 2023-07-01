sub menu ( $prompt, @items ) {
    return '' unless @items.elems;
    repeat until my $selection ~~ /^ \d+ $/ && @items[--$selection] {
        my $i = 1;
        say "  {$i++}) $_" for @items;
        $selection = prompt $prompt;
    }
    return @items[$selection];
}

my @choices = 'fee fie', 'huff and puff', 'mirror mirror', 'tick tock';
my $prompt = 'Enter the number corresponding to your selection: ';

my $answer = menu( $prompt, [] );
say "You chose: $answer" if $answer.chars;

$answer = menu( $prompt, @choices );
say "You chose: $answer" if $answer.chars;
