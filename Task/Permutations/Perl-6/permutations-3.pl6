sub permute(@items) {
   my @seq := 1..+@items;
   gather for (^[*] @seq) -> $n is copy {
      my @order;
      for @seq {
         unshift @order, $n mod $_;
         $n div= $_;
      }
      my @i-copy = @items;
      take [ map { @i-copy.splice($_, 1) }, @order ];
   }
}
.say for permute( 'a'..'c' )
