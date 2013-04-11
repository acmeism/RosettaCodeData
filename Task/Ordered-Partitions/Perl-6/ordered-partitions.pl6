sub partition(@mask is copy) {
    my $last = [+] @mask or return [[] xx @mask];
    sort gather for @mask.kv -> $k,$v {
        next unless $v;
        temp @mask[$k] -= 1;
        for partition @mask { .take.[$k].push($last) }
    }
}

.perl.say for partition [2,0,2];
