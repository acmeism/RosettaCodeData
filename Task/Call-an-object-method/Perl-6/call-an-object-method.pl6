class C {
  method some-method(){ say 'I haz a method' }
};
my C $a-c.=new; # we need an instance of C
$a-c.some-method; # so we can call a method

sub not-a-method(Any:D $obj){ say $obj.WHAT }; # *.WHAT stringifies to the typename in parentheses
$a-c.&not-a-method; # output: '(C)'
my @many-cs = C.new xx 3; # a List of 3 Cs
@many-cs>>.&not-a-method; # let's call not-a-method on all 3 Cs at once
                          # the >>. hyperoperator is a candidate for autothreading so your order of execution may vary
my $runtime-method-name = 'some-method';
$a-c."$runtime-method-name"(); # here some very late binding

my multi method free-floating-method($self:){ # my is required or the compiler thinks we misplaced a method
  say 'i haz a C' if $self ~~ C # we do the type check by hand
};

free-floating-method($a-c); # $self is bound to the first parameter
$a-c.&free-floating-method; # dito but automatically

$a-c.?does-not-exist; # this method does not exist so it's not called thanks to .?

use MONKEY-TYPING;
augment class Int {
  method does-not-exists(){} # This is one way to add a method. As usual there are more then one.
}

$a-c.?does-not-exists; # now it exists and we can call it

my multi method free-floating-method(C:D $self:){} # we could let the compiler do the type check
my multi method free-floating-method(Int:D $self:){} # or let it pick the right candidate
my @a-good-mix = (Int.new((1..100).roll),C.new).roll xx 5; # let's have a mixture of Cs and Ints
@a-good-mix>>.&free-floating-method; # and let Perl 6 pick the right candidate for us

C.some-method(); # actually we don't really need an instance of C. We can call class methods aswell.
