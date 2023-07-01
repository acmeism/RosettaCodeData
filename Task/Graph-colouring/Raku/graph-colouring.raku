sub GraphNodeColor(@RAW) {
   my %OneMany = my %NodeColor;
   for @RAW { %OneMany{$_[0]}.push: $_[1] ; %OneMany{$_[1]}.push: $_[0] }
   my @ColorPool = "0", "1" … ^+%OneMany.elems; # as string
   my %NodePool  = %OneMany.BagHash; # this DWIM is nice
   if %OneMany<NaN>:exists { %NodePool{$_}:delete for %OneMany<NaN>, NaN } # pending
   while %NodePool.Bool {
      my $color = @ColorPool.shift;
      my %TempPool = %NodePool;
      while (my \n = %TempPool.keys.sort.first) {
         %NodeColor{n} = $color;
         %TempPool{n}:delete;
         %TempPool{$_}:delete for @(%OneMany{n}) ; # skip neighbors as well
         %NodePool{n}:delete;
      }
   }
   if %OneMany<NaN>:exists { # islanders use an existing color
      %NodeColor{$_} = %NodeColor.values.sort.first for @(%OneMany<NaN>)
   }
   return %NodeColor
}

my \DATA = [
   [<0 1>,<1 2>,<2 0>,<3 NaN>,<4 NaN>,<5 NaN>],
   [<1 6>,<1 7>,<1 8>,<2 5>,<2 7>,<2 8>,<3 5>,<3 6>,<3 8>,<4 5>,<4 6>,<4 7>],
   [<1 4>,<1 6>,<1 8>,<3 2>,<3 6>,<3 8>,<5 2>,<5 4>,<5 8>,<7 2>,<7 4>,<7 6>],
   [<1 6>,<7 1>,<8 1>,<5 2>,<2 7>,<2 8>,<3 5>,<6 3>,<3 8>,<4 5>,<4 6>,<4 7>],
];

for DATA {
   say "DATA   : ", $_;
   say "Result : ";
   my %out = GraphNodeColor $_;
   say "$_[0]-$_[1]:\t Color %out{$_[0]} ",$_[1].isNaN??''!!%out{$_[1]} for @$_;
   say "Nodes  : ", %out.keys.elems;
   say "Edges  : ", $_.elems;
   say "Colors : ", %out.values.Set.elems;
}
