sub huffman (%frequencies) {
    my @queue = %frequencies.map: { .value => (hash .key => '') };
    while @queue > 1 {
        @queue.=sort;
        my $x = @queue.shift;
        my $y = @queue.shift;
        @queue.push: ($x.key + $y.key) => hash $x.value.deepmap('0' ~ *),
                                               $y.value.deepmap('1' ~ *);
    }
    @queue[0].value;
}
