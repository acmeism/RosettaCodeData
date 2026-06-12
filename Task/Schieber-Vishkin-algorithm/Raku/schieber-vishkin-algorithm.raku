# 20250716 Raku programming solution

# Node class for triply linked tree
class Node { has Int ($.child, $.sib, $.parent) is rw is default(0) }

# Result class to hold algorithm outputs
class Result { has Int (@.pi, @.beta, @.alfa, @.tau, @.lam) }

# Main processing function implementing Schieber-Vishkin algorithm
sub process(Int $n, @a) returns Result {
   my Int (@pi, @beta, @alfa, @tau, @lam);
   my Node @nodes = Node.new xx ($n + 1);

   # Make triply linked tree
   my Int $t = 0;
   for $n...1 -> $v {
      my Int $u = 0;
      while @a[$v] > @a[$t] || (@a[$v] == @a[$t] && $v > $t) {
         $t = @nodes[ $u = $t ].parent;
      }
      if $u != 0 {
         (@nodes[$v].sib,@nodes[$u].sib,@nodes[$u].parent,@nodes[$v].child) =
          @nodes[$u].sib,             0,               $v,              $u;
      } else {
         @nodes[$v].sib = @nodes[$t].child;
      }
      @nodes[@nodes[$t].child = $v].parent = $t;
      $t = $v;
   }
   # First traversal
   my Int ($p, $n-count) = @nodes[0].child, 0;
   @lam[0] = -1;

   # Inner traversal function
   sub traversal() returns Bool {
      loop {
         @pi[$p] = ++$n-count;
         @tau[$n-count] = 0;
         @lam[$n-count] = 1 + @lam[$n-count +> 1];
         if @nodes[$p].child != 0 { $p = @nodes[$p].child and next }
         @beta[$p] = $n-count;
         last;
      }
      loop {
         @tau[@beta[$p]] = @nodes[$p].parent;
         if @nodes[$p].sib != 0 {
            $p = @nodes[$p].sib;
            return True;
         }
         $p = @nodes[$p].parent;
         if $p != 0 {
            my Int $h = @lam[$n-count +& (-@pi[$p])];
            @beta[$p] = (($n-count +> $h) +| 1) +< $h;
         } else {
            return False;
         }
      }
   }
   while traversal() { } # Perform first traversal

   # Second traversal
   (             $p,        @lam[0], @pi[0], @beta[0], @alfa[0] ) =
    @nodes[0].child, @lam[$n-count],      0,        0,        0 ;

   # Recursive function for computing alfa
   sub compute-alfa(Int $node) {
      @alfa[$node] = @alfa[@nodes[$node].parent] +| (@beta[$node] +& (-@beta[$node]));
      if @nodes[$node].child != 0 { compute-alfa(@nodes[$node].child) }
      if @nodes[$node].sib   != 0 { compute-alfa(@nodes[$node].sib) }
   }
   compute-alfa($p) if $p != 0;  # Perform second traversal if needed
   return Result.new(:pi(@pi),:beta(@beta),:alfa(@alfa),:tau(@tau),:lam(@lam));
}

# Compute nearest common ancestor
sub nca(Int $x is copy, Int $y is copy, @beta, @alfa, @tau, @lam, @pi) returns Int {
   my Int $h = @beta[$x] <= @beta[$y] ?? @lam[@beta[$y] +& (-@beta[$x])]
                                      !! @lam[@beta[$x] +& (-@beta[$y])];
   my Int $k = @alfa[$x] +& @alfa[$y] +& (-(1 +< $h));
   $h = @lam[$k +& (-$k)];
   my Int $j = ((@beta[$x] +> $h) +| 1) +< $h;
   if $j != @beta[$x] {
      my Int $l = @lam[@alfa[$x] +& ((1 +< $h) - 1)];
      $x = @tau[((@beta[$x] +> $l) +| 1) +< $l];
   }
   if $j != @beta[$y] {
      my Int $l = @lam[@alfa[$y] +& ((1 +< $h) - 1)];
      $y = @tau[((@beta[$y] +> $l) +| 1) +< $l];
   }
   return @pi[$x] <= @pi[$y] ?? $x !! $y;
}

# Generic solver function
sub solve-test-case-generic(Int $n, @values, @queries, &executor) {
   my Int @a = uint.Range.max; # 2**31 - 1
   my Int @r = 0 xx ($n + 2);
   my Int @b = 0 xx ($n + 2);
   my Int $big-n = 1;
   my Int $count = 0;
   my $oldx;
   for 1..$n -> $i {
      my Int $x = @values[$i - 1];
      if $i > 1 && (!$oldx.defined || $x != $oldx) {
         @a.push($count);
         @r[$big-n] = $i;
         $big-n++;
         $count = 0;
      }
      @b[$i] = $big-n;
      $count++;
      $oldx = $x;
   }
   @a.push($count);
   @r[$big-n] = $n + 1;

   given my Result $result = process($big-n, @a) {
      return executor(@queries, @a, @r, @b, .pi, .beta, .alfa, .tau, .lam)
   }
}

# Serial executor
sub run-serial( @queries, @a, @r, @b, @pi, @beta, @alfa, @tau, @lam) {
   return @queries.map: -> @query {
      my ($i, $j) = @query[0], @query[1];   # keep 1-based
      my ($x, $y) = @b[$i], @b[$j];

      do if $x == $y { # same block: contiguous run
         $j - $i + 1;
      } else {
         # 1) base = either nca-block or 0 if adjacent segments
         my Int $base = ($x + 1 != $y)
                        ?? @a[ nca($x+1, $y-1, @beta, @alfa, @tau, @lam, @pi) ]
                        !! 0;
         # 2) include partial runs at both ends
         my Int $left  = @r[$x]      - $i;
         my Int $right = @a[$y] - @r[$y] + $j + 1;

         max($base, $left, $right);
      }
   }
}

# Race executor ( mediocre implementation )
sub run-race(@queries, @a, @r, @b, @pi, @beta, @alfa, @tau, @lam) {
   return @queries.batch(1000).race.map({
      |(.map: -> @query {
         my ($i, $j) = @query[0], @query[1];
         my ($x, $y) = @b[$i], @b[$j];

         do if $x == $y {
            $j - $i + 1;
         } else {
            my $z = $x+1 != $y ?? @a[nca($x+1,$y-1,@beta,@alfa,@tau,@lam,@pi)]
                               !! 0;
            max($z, @r[$x] - $i, @a[$y] - @r[$y] + $j + 1);
         }
      })
   });
}

# Async executor ( mediocre implementation )
sub run-async(@queries, @a, @r, @b, @pi, @beta, @alfa, @tau, @lam) {
   my @promises = @queries.batch(1000).map: -> @chunk {
      start {
         @chunk.map: -> @query {
            my ($i, $j) = @query[0], @query[1];
            my ($x, $y) = @b[$i], @b[$j];

            do if $x == $y {
               $j - $i + 1;
            } else {
               my $z = $x + 1 != $y
                       ?? @a[nca($x + 1, $y - 1, @beta, @alfa, @tau, @lam, @pi)]
                       !! 0;
               max($z, @r[$x] - $i, @a[$y] - @r[$y] + $j + 1);
            }
         }
      }
   }
   return await(@promises).flat;
}

sub print-query-results(@queries, @results, @expected, Str $mode) {
   say "Queries and Results ($mode):";
   for @queries.kv -> $q-idx, @query {
      my ($i, $j) = @query[0], @query[1];
      my $result = @results[$q-idx];
      my $expected = @expected[$q-idx];
      say "Query: $i $j";
      say "Result: $result (Expected: $expected)";
      if $result != $expected {
         say "  WARNING: Result doesn't match expected output";
      }
   }
   say "";
}

my @test-cases = ({
   n        => 10,
   values   => [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
   queries  => [[2, 3], [1, 10], [5, 10]],
   expected => [1, 4, 3]
},);

say "Output similar to the Go entry:\n";
for @test-cases.kv -> $idx, %test-case {
   say "Test Case {$idx + 1}:";
   my @results = solve-test-case-generic( %test-case<n>,
                                          %test-case<values>,
                                          %test-case<queries>,
                                          &run-serial           );
   say "Result: {@results} (Expected: %test-case<expected>)";
}

say "\nOutput similar to the Julia entry:\n";

my @executors = [
   ['Sequential', &run-serial],
   ['Race', &run-race],
   ['Async', &run-async],
];

for @test-cases.kv -> $idx, %test-case {
   say "Test Case {$idx + 1}:";
   say "Size: {%test-case<n>}, Queries: {%test-case<queries>.elems}";
   say "Values: {%test-case<values>.join(' ')}\n";

   for @executors -> $executor {
      my ($label, $code) = $executor;
      my @results = solve-test-case-generic( %test-case<n>,
                                             %test-case<values>,
                                             %test-case<queries>,
                                             $code                );
      print-query-results( %test-case<queries>,  @results,
                           %test-case<expected>,   $label);
   }
}

#`[[[[[[ nothing worthy of attention for now

# Demonstration of different approaches

my Int $n = 8000;
my @values = ^$n .map: { rand < 0.1 ?? -1 !! (1 + floor(rand * 1000)) };

my Int $query-count = 200;
my @queries = (^$query-count).map: { minmax (1..$n).pick, (1..$n).pick };

# Just test performance, don't compare expected outputs
say "Benchmarking on N=$n, Queries=$query-count\n";

for (
   [ 'Method 0: Plain serial processing',              &run-serial ],
   [ 'Method 1: Using .race (data parallelism)',         &run-race ],
   [ 'Method 2: Using start blocks (async processing)', &run-async ],
) -> ($label, $executor) {
   say $label;
   my $start-time = now;
   my @results = solve-test-case-generic($n, @values, @queries, $executor);
   my $elapsed = now - $start-time;
   say "Completed in {$elapsed.round(0.001)} seconds\n";
}

#]]]]]]
