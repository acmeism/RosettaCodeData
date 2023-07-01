# 20221114 Raku programming solution

my ($rounds,$size) = 3, 2000;
my @allones        = 1 xx $size;
my @sequential     = 1 .. $size;
my @randomized     = @sequential.roll xx $size;

sub insertion_sort ( @a is copy ) { # rosettacode.org/wiki/Sorting_algorithms/Insertion_sort#Raku
   for 1 .. @a.end -> \k {
      loop (my ($j,\value)=k-1,@a[k];$j>-1&&@a[$j]>value;$j--) {@a[$j+1]=@a[$j]}
      @a[$j+1] = value;
   }
   return @a;
}

sub merge_sort ( @a ) { # rosettacode.org/wiki/Sorting_algorithms/Merge_sort#Raku
    return @a if @a <= 1;

    my $m = @a.elems div 2;
    my @l = merge_sort @a[  0 ..^ $m ];
    my @r = merge_sort @a[ $m ..^ @a ];

    return flat @l, @r if @l[*-1] !after @r[0];
    return flat gather {
        take @l[0] before @r[0] ?? @l.shift !! @r.shift
            while @l and @r;
        take @l, @r;
    }
}

sub quick-sort(@data) { # andrewshitov.com/2019/06/23/101-quick-sort-in-perl-6/
    return @data if @data.elems <= 1;

    my ($pivot,@left, @right) = @data[0];

    for @data[1..*] -> $x { $x < $pivot ?? push @left, $x !! push @right, $x }

    return flat(quick-sort(@left), $pivot, quick-sort(@right));
}

sub comparesorts($rounds, @tosort) {
   my ( $iavg, $mavg, $qavg, $t );

   for (<i m q> xx $rounds).flat.pick(*) -> \sort_type {
      given sort_type {
         when 'i' { $t = now ; insertion_sort @tosort ; $iavg += now - $t }
         when 'm' { $t = now ; merge_sort     @tosort ; $mavg += now - $t }
	 when 'q' { $t = now ; quick-sort     @tosort ; $qavg += now - $t }
      }
   }
   return $iavg, $mavg, $qavg  »/»  $rounds
}

for <ones presorted randomized>Z(@allones,@sequential,@randomized) -> ($t,@d) {
   say "Average sort times for $size $t:";
   { say "\tinsertion sort\t$_[0]\n\tmerge sort\t$_[1]\n\tquick sort\t$_[2]" }(comparesorts $rounds,@d)
}
