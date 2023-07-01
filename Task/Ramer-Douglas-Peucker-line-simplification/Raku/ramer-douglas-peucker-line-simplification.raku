sub norm (*@list) { @list»².sum.sqrt }

sub perpendicular-distance (@start, @end where @end !eqv @start, @point) {
    return 0 if @point eqv any(@start, @end);
    my ( $Δx, $Δy ) =   @end «-» @start;
    my ($Δpx, $Δpy) = @point «-» @start;
    ($Δx, $Δy) «/=» norm $Δx, $Δy;
    norm ($Δpx, $Δpy) «-» ($Δx, $Δy) «*» ($Δx*$Δpx + $Δy*$Δpy);
}

sub Ramer-Douglas-Peucker(@points where * > 1, \ε = 1) {
    return @points if @points == 2;
    my @d = (^@points).map: { perpendicular-distance |@points[0, *-1, $_] };
    my ($index, $dmax) = @d.first: @d.max, :kv;
    return flat
      Ramer-Douglas-Peucker( @points[0..$index], ε )[^(*-1)],
      Ramer-Douglas-Peucker( @points[$index..*], ε )
      if $dmax > ε;
    @points[0, *-1];
}

# TESTING
say Ramer-Douglas-Peucker(
   [(0,0),(1,0.1),(2,-0.1),(3,5),(4,6),(5,7),(6,8.1),(7,9),(8,9),(9,9)]
);
