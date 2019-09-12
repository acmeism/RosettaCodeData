class Cell {
    has      $.value is rw;
    has Cell $.next  is rw;

    # ...convenience methods here...
}

sub cons ($value, $next) { Cell.new(:$value, :$next) }

my $list = cons 10, (cons 20, (cons 30, Nil));
