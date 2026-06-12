# 20240220 Raku programming solution

class Cell { has ($.value, $.next) is rw;

   method reverse {
      my ($list, $prev) = self, Nil;
      while $list.defined {
         my $next = $list.next;
         $list.next = $prev;
         ($list, $prev) = ($next, $list)
      }
      return $prev;
   }

   method gist {
      my $cell = self;
      return ( gather while $cell.defined {
         take $cell.value andthen $cell = $cell.next;
      } ).Str
   }
}

sub cons ($value, $next = Nil) { Cell.new(:$value, :$next) }

my $list = cons 10, (cons 20, (cons 30, (cons 40, Nil)));

say $list = $list.reverse;
say $list = $list.reverse;
