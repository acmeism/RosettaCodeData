# 20250512 Raku programming solution

# least common ancestor of x and y in the alternating forest
sub lca($x is copy, $y is copy, @bases, @matches, @paths, $n) {
   my @usedPath = False xx $n;
   loop {
      @usedPath[$x = @bases[$x]] = True;
      @matches[$x] < 0 ?? ( last ) !! $x = @paths[@matches[$x]]
   }
   loop {
      @usedPath[$y = @bases[$y]].Bool ?? ( last ) !! $y = @paths[@matches[$y]]
   }
   return $y;
}

# mark path from v up to base0, setting parents to x
sub markPath($v is copy, $base0, $x is copy, @bases, @matches, @paths, @blossom) {
   while @bases[$v] != $base0 {
      my $mv = @matches[$v];
      @blossom[@bases[$mv]] = @blossom[@bases[$v]] = True;
      @paths[$v] = $x;
      $v = @paths[ $x = $mv ];
   }
}

# attempt to find an augmenting path from root
sub findPath(@adj, $root, $n, @matches is copy) {
   my @paths = -1 xx $n;
   my @bases = ^$n;
   my @queue = ($root);
   my (@used, @blossom) is default( False );
   @used[$root] = True;

   while my $v = @queue.shift {
      for @adj[$v].flat -> $u {
         next unless @bases[$v] != @bases[$u] && @matches[$v] != $u;
         if $u == $root || (@matches[$u] != -1 && @paths[@matches[$u]] != -1) {
            # Found a blossom; contract it
            my $curbase = lca($v, $u, @bases, @matches, @paths, $n);
            markPath($v, $curbase, $u, @bases, @matches, @paths, @blossom);
            markPath($u, $curbase, $v, @bases, @matches, @paths, @blossom);
            @queue.push: gather for ^$n -> $i {
               if @blossom[@bases[$i]] {
                  @bases[$i] = $curbase;
                  unless @used[$i] { @used[take $i] = True }
               }
            }
         } elsif @paths[$u] == -1 { # extend tree
            @paths[$u] = $v;
            if @matches[$u] == -1 { # augmenting path found
               my $v = $u;
               while $v != -1 {
                  my $prev = @paths[$v];
                  my $next = ( $prev != -1 ) ?? @matches[$prev] !! -1;
                  @matches[$v] = $prev;
                  @matches[$prev] = $v if $prev != -1;
                  $v = $next;
               }
               return (@matches, True);
            }
            @used[@matches[$u]] = True;
            @queue.push: @matches[$u];
         }
      }
   }
   return (@matches, False);
}

# find and return the matching array and the size of the matching
sub solve(@adj) {
   my @matches = -1 xx ( my $n = @adj.elems );
   my $res = 0;

   for ^$n -> $v {
      if @matches[$v] == -1 {
         my ($new_matches, $found) = findPath(@adj, $v, $n, @matches);
         if $found {
            @matches = @$new_matches;
            $res++;
         }
      }
   }
   return (@matches, $res);
}

# Example: 5-cycle (0–1–2–3–4–0)
my $n = 5;
my @edges = (0,1), (1,2), (2,3), (3,4), (4,0);
my @adj = [ [] xx $n ];
for @edges -> ($u, $v) {
   @adj[$u].push($v);
   @adj[$v].push($u);
}

my ($matches, $msize) = solve(@adj);
say "Maximum matching size: $msize";
say "Matched pairs:";
for $matches.kv -> $u, $v { say "  $u – $v" if $v != -1 && $u < $v }
