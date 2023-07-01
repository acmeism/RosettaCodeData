sub bogosort (@list is copy) {
    @list .= pick(*) until [<=] @list;
    return @list;
}

my @nums = (^5).map: { rand };
say @nums.sort.Str eq @nums.&bogosort.Str ?? 'ok' !! 'not ok';
