use strict;
use warnings;

package Automaton {
    sub new {
	my $class = shift;
	my $rule = [ reverse split //, sprintf "%08b", shift ];
	return bless { rule => $rule, cells => [ @_ ] }, $class;
    }
    sub next {
	my $this = shift;
	my @previous = @{$this->{cells}};
	$this->{cells} = [
	    @{$this->{rule}}[
	    map {
	      4*$previous[($_ - 1) % @previous]
	    + 2*$previous[$_]
	    +   $previous[($_ + 1) % @previous]
	    } 0 .. @previous - 1
	    ]
	];
	return $this;
    }
    use overload
    q{""} => sub {
	my $this = shift;
	join '', map { $_ ? '#' : ' ' } @{$this->{cells}}
    };
}

my @a = map 0, 1 .. 91; $a[45] = 1;
my $a = Automaton->new(90, @a);

for (1..40) {
    print "|$a|\n"; $a->next;
}
