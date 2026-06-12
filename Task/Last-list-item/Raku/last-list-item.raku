say ' Original ', my @list = 6, 81, 243, 14, 25, 49, 123, 69, 11;

say push @list: get(min @list) + get(min @list) while @list > 1;

sub get ($min) {
    @list.splice: @list.first(* == $min, :k), 1;
    printf " %3d ", $min;
    $min;
}
