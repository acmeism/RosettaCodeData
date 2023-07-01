my $ask_count = 0;
sub by_asking ( $a, $b ) {
    $ask_count++;
    constant $fmt = '%2d. Is %-6s [ less than | greater than | equal to ] %-6s? ( < = > ) ';
    constant %o = '<' => Order::Less,
                  '=' => Order::Same,
                  '>' => Order::More;

    loop {
        my $input = prompt sprintf $fmt, $ask_count, $a, $b;
        return $_ with %o{ $input.trim };
        say "Invalid input '$input'";
    }
}

my @colors = <violet red green indigo blue yellow orange>;
my @sorted = @colors.sort: &by_asking;
say (:@sorted);

die if @sorted».substr(0,1).join ne 'roygbiv';
my $expected_ask_count = @colors.elems * log(@colors.elems);
warn "Too many questions? ({:$ask_count} > {:$expected_ask_count})" if $ask_count > $expected_ask_count;
