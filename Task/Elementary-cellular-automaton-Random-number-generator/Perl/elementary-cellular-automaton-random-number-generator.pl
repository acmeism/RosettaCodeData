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

my $a = Automaton->new(30, 1, map 0, 1 .. 100);

for my $n (1 .. 10) {
    my $sum = 0;
    for my $b (1 .. 8) {
	$sum = $sum * 2 + $a->{cells}[0];
	$a->next;
    }
    print $sum, $n == 10 ? "\n" : " ";
}
