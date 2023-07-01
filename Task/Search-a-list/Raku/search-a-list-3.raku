my @haystack = <Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo>;

my %index;
%index{.value} //= .key for @haystack.pairs;

for <Washington Bush> -> $needle {
    say "$needle -- { %index{$needle} // 'not in haystack' }";
}
