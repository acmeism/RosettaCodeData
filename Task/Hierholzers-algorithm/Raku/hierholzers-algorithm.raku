say join ' -> ', .&hierholser for ([1],[2],[0]), ([1,6],[2],[0,3],[4],[2,5],[0],[4]);

sub hierholser (@graph) {
    my @cycle = 0;
    @cycle.push: @graph[@cycle.tail].pop while @graph[@cycle.tail].elems;
    @cycle;
}
