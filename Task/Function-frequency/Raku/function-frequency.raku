my $text = qqx[raku --target=ast @*ARGS[]];
my %fun;
for $text.lines {
    %fun{$0}++ if / '(call &' (.*?) ')' /
}

for %fun.invert.sort.reverse[^10] { .value.say }
