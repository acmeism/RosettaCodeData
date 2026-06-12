# 20250615 Raku programming solution

class Node {
   has %!son;           # Transitions for each character
   has Int $!fail = 0;  # Failure link
   has Int $!idx = 0;   # Index of the pattern ending at this node
   has Int $!ans = 0;   # Answer for occurrences of patterns
   has Int $!du = 0;    # Incoming edge count for topological sorting

   method add-transition(Str $char, Int $state) { %!son{$char} = $state }
   method get-transition(Str $char) { %!son{$char} // 0 }
   method set-fail(Int $state) { $!fail = $state }
   method fail { $!fail }
   method set-idx(Int $index) { $!idx = $index }
   method idx { $!idx }
   method increment-ans { $!ans++ }
   method add-ans(Int $count) { $!ans += $count }
   method ans { $!ans }
   method increment-du { $!du++ }
   method decrement-du { $!du-- }
   method du { $!du }
}

class ACAutomaton {
   has @!trie = Node.new;    # Trie nodes
   has Int $!tot = 0;        # Total number of nodes
   has Int $!pattern-id = 0; # Pattern ID counter
   has @!final-ans;          # Final results for patterns

   method insert(Str $pattern) {
      my $current = 0;
      for $pattern.comb -> $char {
         unless @!trie[$current].get-transition($char) {
            $!tot++;
            @!trie.push(Node.new);
            @!trie[$current].add-transition($char, $!tot);
         }
         $current = @!trie[$current].get-transition($char);
      }
      if @!trie[$current].idx == 0 {
         $!pattern-id++;
         @!trie[$current].set-idx($!pattern-id);
      }
      @!trie[$current].idx;
   }

   method build {
      my @queue = gather for 'a'..'z' -> $char {
         if my $state = @!trie[0].get-transition($char) { take $state }
      }

      while my $state = @queue.shift {
         for 'a'..'z' -> $char {
            my $fail = @!trie[$state].fail;
            if my $son = @!trie[$state].get-transition($char) {
               @!trie[$son].set-fail(@!trie[$fail].get-transition($char));
               @!trie[@!trie[$son].fail].increment-du;
               @queue.push($son);
            } else {
               @!trie[$state].add-transition($char, @!trie[$fail].get-transition($char));
            }
         }
      }
   }

   method query(Str $text) {
      my $current = 0;
      for $text.comb -> $char {
         $current = @!trie[$current].get-transition($char);
         @!trie[$current].increment-ans;
      }
   }

   method calculate-final-answers {
      @!final-ans = (0 xx ($!pattern-id + 1));
      my @queue = (0..$!tot).grep: { @!trie[$_].du == 0 }

      while @queue.Bool {
         my $idx = @!trie[my $state = @queue.shift].idx;
         @!final-ans[$idx] = @!trie[$state].ans if $idx;
         @!trie[my $fail = @!trie[$state].fail].add-ans(@!trie[$state].ans);
         @!trie[$fail].decrement-du;
         if @!trie[$fail].du == 0 { @queue.push($fail) }
      }
   }

   method get-final-answers { @!final-ans }
}

my @patterns = <a bb aa abaa abaaa>;
my $text = "abaaabaa";
my $aca = ACAutomaton.new;
my @end-node-ids = @patterns.map: { $aca.insert: $_ }

$aca.build;
$aca.query($text);
$aca.calculate-final-answers;

for ^@patterns.elems -> $i {
   my $id = @end-node-ids[$i];
   say "The pattern '{@patterns[$i]}' appears {$aca.get-final-answers[$id]} times."
}
