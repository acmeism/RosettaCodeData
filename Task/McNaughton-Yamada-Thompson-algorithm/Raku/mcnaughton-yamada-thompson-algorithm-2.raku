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

grammar RegexGrammar {
   token TOP { <expr> }
                                                                 # precedence
   token expr { <concat-expr>+ % '|' }   # Handle alternation       lowest

   token concat-expr { <factor>+ % '.' } # Handle concatenation     higher

   token factor { <atom> <quantifier>? } # Handle quantifiers       highest

   token atom {
      | <literal>
      | '(' <expr> ')'
   }

   token literal { <-[().*+?|]> }

   token quantifier { '*' | '+' | '?' }
}

class RegexActions {

   method literal($/) {
      my $initial = State.new(~$/);
      my $accept = State.new;
      $initial.edge1 = $accept;
      make NFA.new($initial, $accept);
   }

   method quantifier($/) {
      return make %( < * + ? > Z=> < kleene plus optional >).{~$/}
   }

   method factor($/) {
      my $nfa = $<atom>.made;
      my State ($initial, $accept)».=new;

      if $<quantifier> {
         given $<quantifier>.made {
            $initial.edge1 = $nfa.initial;
            when 'kleene' {
               $initial.edge2 = $accept;
               given $nfa.accept { (.edge1, .edge2) = $nfa.initial, $accept }
            }
            when 'plus' {
               given $nfa.accept { (.edge1, .edge2) = $nfa.initial, $accept }
            }
            when 'optional' {
               ($initial.edge2, $nfa.accept.edge1) = $accept xx 2
            }
         }
         $nfa = NFA.new($initial, $accept);
      }
      return make $nfa
   }

   method atom($/) {
       make do if $<literal> { $<literal>.made } elsif $<expr> { $<expr>.made }
   }

   method concat-expr($/) {
      my @factors = $<factor>».made;
      my $result = @factors.shift;

      for @factors -> $nfa { # Concatenation - connect NFAs in sequence
         $result.accept.edge1 = $nfa.initial;
         $result = NFA.new($result.initial, $nfa.accept);
      }
      return make $result;
   }

   method expr($/) {
      my @concat-exprs = $<concat-expr>».made;

      return do if @concat-exprs == 1 {
         make @concat-exprs[0];
      } else { # Alternation - create choice between alternatives
         my State ($initial, $accept)».=new;

         # Connect initial state to all alternatives
         given $initial { (.edge1, .edge2) = @concat-exprs[0,1]».initial }

         # Connect all alternatives to accept state
         .accept.edge1 = $accept for @concat-exprs[0,1];

         my $result = NFA.new($initial, $accept);

         # Handle more than 2 alternatives by building binary tree
         for @concat-exprs[2..*] -> $nfa {
            my State ($new-initial, $new-accept)».=new;
            given $new-initial { (.edge1, .edge2) = ($result, $nfa)».initial }
            ($result.accept.edge1, $nfa.accept.edge1) = $new-accept xx 2;
            $result = NFA.new($new-initial, $new-accept);
         }
         make $result;
      }
   }

   method TOP($/) { make $<expr>.made }
}

class GrammarMYT {
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

   method match-regex(Str $text, Str $regex) {
      my $actions = RegexActions.new;
      return False unless my $parsed = RegexGrammar.parse($regex, :$actions);
      my $nfa = $parsed.made;
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

say "=== Grammar-based Approach ===";
my $grammar-based = GrammarMYT.new;

for @infixes -> $infix {
   for @strings -> $string {
      say $grammar-based.match-regex($string, $infix) ~ "\t$infix\t$string"
   }
   say ""
}
