# 20240908 Updated Raku programming solution

sub pancake-sort(@data is copy) { # imperative
   for @data.elems - 1 ... 1 {
      @data[0 .. @data[0..$_].maxpairs[*-1].key] .= reverse;
      @data[0 .. $_] .= reverse;
   }
   return @data
}

sub pancake_sort(@data is copy) { # recursive
   return @data if @data.elems <= 1;
   @data[0 .. @data.maxpairs[*-1].key] .= reverse;
   return pancake_sort(@data[1..*-1]).append: @data[0]
}

for <6 7 2 1 8 9 5 3 4>,
    <4 5 7 1 46 78 2 2 1 9 10>,
    <0 -9 -8 2 -7 8 6 -2 -8 3> -> @data {
   say 'input  = ' ~ @data;
   say 'output = ' ~ pancake-sort(@data);
   say 'output = ' ~ pancake_sort(@data) ~ "\n"
}
