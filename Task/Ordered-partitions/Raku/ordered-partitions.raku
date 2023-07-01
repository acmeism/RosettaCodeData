sub partition(@mask is copy) {
    my @op;
    my $last = [+] @mask or return [] xx 1;
    for @mask.kv -> $k, $v {
        next unless $v;
        temp @mask[$k] -= 1;
        for partition @mask -> @p {
            @p[$k].push: $last;
            @op.push: @p;
        }
    }
    return @op;
}

.say for reverse partition [2,0,2];
