# 20250616 Raku programming solution

class State {
   has $.label is rw;        # Character label, Nil for epsilon
   has State $.edge1 is rw;  # First transition
   has State $.edge2 is rw;  # Second transition

   method new($label = Nil) { self.bless(:$label) }
}

class NFA {
   has State ($.initial, $.accept) is rw;

   method new(State $initial, State $accept) { self.bless(:$initial, :$accept) }
}

class TraditionalMYT { # Traditional approach using shunting-yard algorithm
   method shunt(Str $infix) {
      my %specials = '*' => 60, '+' => 55, '?' => 50, '.' => 40, '|' => 20;
      my ($postfix, @stack);

      for $infix.comb -> $c {
         given $c {
            when '(' { @stack.push($c) }
            when ')' {
               while @stack && @stack[*-1] ne '(' { $postfix ~= @stack.pop }
               @stack.pop if @stack; # Remove '('
            }
            when * ∈ %specials.keys {
               while @stack && @stack[*-1] ∈ %specials.keys      &&
                     %specials{$c}         ≤ %specials{@stack[*-1]} {
                  $postfix ~= @stack.pop;
               }
               @stack.push($c);
            }
            default { $postfix ~= $c }
         }
      }
      return $postfix ~= @stack.reverse.join;
   }

   method followes(State $state) {
      my $states = SetHash.new;
      my @stack = $state;

      while my $s = @stack.pop and $s ∉ $states {
         $states{$s}++;
         without $s.label { # Epsilon transition
            for ($s.edge1, $s.edge2) { @stack.push: $_ if .defined }
         }
      }
      return $states.keys.Set;
   }

   method compile-regex(Str $postfix) {
      my @nfa-stack;

      for $postfix.comb -> $c {
         @nfa-stack.push: do given $c {
            my State ($initial, $accept)».=new;
            when '*' {
               my $nfa1 = @nfa-stack.pop;
               ($initial.edge1, $nfa1.accept.edge1) = $nfa1.initial xx 2;
               ($initial.edge2, $nfa1.accept.edge2) = $accept       xx 2;
               NFA.new($initial, $accept)
            }
            when '.' {
               my ($nfa1, $nfa2)  =  @nfa-stack.splice: *-2, 2;
               $nfa1.accept.edge1 = $nfa2.initial;
               NFA.new($nfa1.initial, $nfa2.accept)
            }
            when '|' {
               my ($nfa1, $nfa2)  =  @nfa-stack.splice: *-2, 2;
               given $initial { (.edge1, .edge2) = ($nfa1,$nfa2)».initial }
               ($nfa1.accept.edge1, $nfa2.accept.edge1) = $accept xx 2;
               NFA.new($initial, $accept)
            }
            when '+' {
               my $nfa1 = @nfa-stack.pop;
               $initial.edge1 = $nfa1.initial;
               given $initial.accept { (.edge1,.edge2) = $nfa1.initial,$accept }
               NFA.new($initial, $accept)
            }
            when '?' {
               my $nfa1 = @nfa-stack.pop;
               given $initial { (.edge1, .edge2) = $nfa1.initial, $accept }
               $nfa1.accept.edge1 = $accept;
               NFA.new($initial, $accept)
            }
            default { # Literal character
               $initial = State.new($c);
               $initial.edge1 = $accept;
               NFA.new($initial, $accept)
            }
         }
      }
      return @nfa-stack[0];
   }

   method match-regex(Str $text, Str $infix) {
      my $postfix = self.shunt($infix);
      # say "Postfix: $postfix"; # Uncomment to see postfix
      my $nfa = self.compile-regex($postfix);
      my $current = self.followes($nfa.initial);

      for $text.comb -> $ch {
         my $next-states = SetHash.new;
         for $current.keys -> $state {
            if $state.label.defined && $state.label eq $ch {
               $next-states{$_}++ for self.followes($state.edge1).keys
            }
         }
         $current = $next-states.keys.Set;
      }
      return $nfa.accept ∈ $current;
   }
}

my @infixes = "a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c";
my @strings = "", "abc", "abbc", "abcc", "abad", "abbbc";

say "=== Traditional Approach (Shunting Yard) ===";
my $traditional = TraditionalMYT.new;

for @infixes -> $infix {
   for @strings -> $string {
      say $traditional.match-regex($string, $infix) ~ "\t$infix\t$string"
   }
   say ""
}
