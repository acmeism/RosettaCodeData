use v5.36;

package Trit;
use List::Util qw(min max);

our @ISA = qw(Exporter);
our @EXPORT = qw(%E);

my %E = (true => 1, false => -1, maybe => 0);

use overload
'<=>' => sub ($a,$b)       { $a->cmp($b)   },
'cmp' => sub ($a,$b)       { $a->cmp($b)   },
'=='  => sub ($a,$b,$)     { $$a == $$b    },
'eq'  => sub ($a,$b,$)     { $a->equiv($b) },
'>'   => sub ($a,$b,$)     { $$a >  $E{$b} },
'<'   => sub ($a,$b,$)     { $$a <  $E{$b} },
'>='  => sub ($a,$b,$)     { $$a >= $$b    },
'<='  => sub ($a,$b,$)     { $$a <= $$b    },
'|'   => sub ($a,$b,$,$,$) { $a->or($b)    },
'&'   => sub ($a,$b,$,$,$) { $a->and($b)   },
'!'   => sub ($a,$,$)      { $a->not()     },
'~'   => sub ($a,$,$,$,$)  { $a->not()     },
'neg' => sub ($a,$,$)      { -$$a          },
'""'  => sub ($a,$,$)      { $a->tostr()   },
'0+'  => sub ($a,$,$)      { $a->tonum()   },
;

sub eqv ($a,$b) {
    $$a == $E{maybe} || $E{$b} == $E{maybe} ? $E{maybe} :       # either arg 'maybe', return 'maybe'
    $$a == $E{false} && $E{$b} == $E{false} ? $E{true}  :       #  both args 'false', return 'true'
                                              min $$a, $E{$b}   # either arg 'false', return 'false', otherwise 'true'
}

# do tests in a manner that avoids overloaded operators
sub new ($class, $v) {
    my $value =
        ! defined $v    ? $E{maybe} :
        $v =~ /true/    ? $E{true}  :
        $v =~ /false/   ? $E{false} :
        $v =~ /maybe/   ? $E{maybe} :
        $v gt $E{maybe} ? $E{true}  :
        $v lt $E{maybe} ? $E{false} :
                          $E{maybe} ;
    bless \$value, $class;
}

sub tostr ($a) { $$a > $E{maybe} ? 'true' : $$a < $E{maybe} ? 'false' : 'maybe' }
sub tonum ($a) { $$a }

sub not   ($a)    { Trit->new( -$a        ) }
sub cmp   ($a,$b) { Trit->new( $a <=> $b  ) }
sub and   ($a,$b) { Trit->new( min $a, $b ) }
sub or    ($a,$b) { Trit->new( max $a, $b ) }
sub equiv ($a,$b) { Trit->new( eqv $a, $b ) }

package main;
Trit->import;

my @a = ( Trit->new($E{true}), Trit->new($E{maybe}), Trit->new($E{false}) );
printf "Codes for logic values: %6s = %d %6s = %d %6s = %d\n", @a[0, 0, 1, 1, 2, 2];

# prefix ! (not) ['~' also can be used]
say "\na\tNOT a";
print "$_\t".(!$_)."\n" for @a;

# infix & (and)
say "\nAND\t" . join("\t",@a);
for my $a (@a) { print $a; print "\t" . ($a & $_)  for @a; say '' }

# infix | (or)
say "\nOR\t" . join("\t",@a);
for my $a (@a) { print $a; print "\t" . ($a | $_)  for @a; say '' }

# infix eq (equivalence)
say "\nEQV\t" . join("\t",@a);
for my $a (@a) { print $a; print "\t" . ($a eq $_) for @a; say '' }

# infix == (equality)
say "\n==\t" . join("\t",@a);
for my $a (@a) { print $a; print "\t" . ($a == $_) for @a; say '' }
