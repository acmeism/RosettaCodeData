my @haystack = <Zig Zag Wally Ronald Bush Krusty Charlie Bush Bozo>;

for <Washington Bush> -> $needle {
    say "$needle -- { @haystack.first($needle, :k) // 'not in haystack' }";
}
