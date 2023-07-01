sub pancake(\n) {
   my @goalStack = (my \numStacks = $ = 1)..n ;
   my %newStacks = my %stacks = @goalStack.Str, 0 ;
   for 1..1000 -> \k {
      my %nextStacks = ();
      for %newStacks.keys».split(' ') X 2..n -> (@arr, \pos) {
         given flat @arr[0..^pos].reverse, @arr[pos..*-1] {
            %nextStacks{$_.Str} = k unless %stacks{$_.Str}:exists
         }
      }
      %stacks ,= (%newStacks = %nextStacks);
      my $perms    = %stacks.elems;
      my %inverted = %stacks.antipairs;      # this causes loss on examples
      my \max_key  = %inverted.keys.max;     # but not critical for our purpose
      $perms == numStacks ?? return %inverted{max_key}, k-1 !! numStacks=$perms
   }
   return '', 0
}

say "The maximum number of flips to sort a given number of elements is:";
for 1..9 -> $j { given pancake($j) { say "pancake($j) = $_[1] example: $_[0]" }}
