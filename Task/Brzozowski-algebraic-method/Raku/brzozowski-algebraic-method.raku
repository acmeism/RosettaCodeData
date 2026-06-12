# 20241120 Raku programming solution

role RE1 { has $.c }
role RE2 { has ( $.e, $.f ) }

class Empty           { method Str { '0' } }
class Epsilon         { method Str { '1' } }
class Car    does RE1 { method Str { $.c } } # Caractère ?
class Star   does RE1 { method Str { "($.c)*" } }
class Union  does RE2 { method Str { "$.e+$.f" } }
class Concat does RE2 { method Str { "($.e)($.f)" } }

my ($empty, $epsilon) = (Empty, Epsilon)>>.new;

sub simple-re($e is rw) {
   sub do-simple($e) {
      given $e {
         when Union {
            my ($ee,$ef) = ($e.e, $e.f).map: { do-simple $_ };
            if    $ee ~~ $ef   { return $ee }
            elsif $ee ~~ Union { do-simple(Union.new(e => $ee.e, f => Union.new(e => $ee.f, f => $ef))) }
            elsif $ee ~~ Empty { return $ef }
            elsif $ef ~~ Empty { return $ee }
            else  { Union.new: e => $ee, f => $ef }
         }
         when Concat {
            my ($ee,$ef) = ($e.e, $e.f).map: { do-simple $_ };
            if    $ee ~~ Epsilon { return $ef }
            elsif $ef ~~ Epsilon {  return $ee }
            elsif $ee ~~ Empty || $ef ~~ Empty { return Empty }
            elsif $ee ~~ Concat { do-simple(Concat.new(e => $ee.e, f => Concat.new(e => $ee.f, f => $ef))) }
            else { Concat.new: e => $ee, f => $ef }
         }
         when Star {
            given do-simple($e.c) {
               $_ ~~ Empty | Epsilon ?? return Epsilon !! Star.new: c => $_
            }
         }
         default { $e }
      }
   }
   my $prev = '';
   until $e === $prev or $e.Str eq $prev { ($prev, $e) = $e, do-simple($e) }
   return $e;
}

sub brzozowski(@a, @b) {
   for @a.elems - 1 ... 0 -> \n {
      @b[n] = Concat.new(e => Star.new(c => @a[n;n]), f => @b[n]);
      for ^n -> \j {
         @a[n;j] = Concat.new(e => Star.new(c => @a[n;n]), f => @a[n;j]);
      }
      for ^n -> \i {
         @b[i] = Union.new(e => @b[i], f => Concat.new(e => @a[i;n], f => @b[n]));
         for ^n -> \j {
            @a[i;j] = Union.new(e => @a[i;j], f => Concat.new(e => @a[i;n], f => @a[n;j]));
         }
      }
      for ^n -> \i { @a[i;n] = $empty }
   }
   return @b[0]
}

my @a = [
    [$empty, Car.new(c => 'a'), Car.new(c => 'b')],
    [Car.new(c => 'b'), $empty, Car.new(c => 'a')],
    [Car.new(c => 'a'), Car.new(c => 'b'), $empty],
];
my @b = [$epsilon, $empty, $empty];

say ( my $re = brzozowski(@a, @b) ).Str;
say simple-re($re).Str;
