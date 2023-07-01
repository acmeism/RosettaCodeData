sub lis(@d) {
    my @l = [].item xx @d;
    @l[0].push: @d[0];
    for 1 ..^ @d -> $i {
        for ^$i -> $j {
            if @d[$j] < @d[$i] && @l[$i] < @l[$j] + 1 {
                @l[$i] = [ @l[$j][] ]
            }
        }
        @l[$i].push: @d[$i];
    }
    return max :by(*.elems), @l;
}

say lis([3,2,6,4,5,1]);
say lis([0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15]);
