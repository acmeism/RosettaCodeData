sub brace_expand {
    my $input = shift;
    my @stack = ([my $current = ['']]);

    while ($input =~ /\G ((?:[^\\{,}]++ | \\(?:.|\z))++ | . )/gx) {
        if ($1 eq '{') {
            push @stack, [$current = ['']];
        }
        elsif ($1 eq ',' && @stack > 1) {
            push @{$stack[-1]}, ($current = ['']);
        }
        elsif ($1 eq '}' && @stack > 1) {
            my $group = pop @stack;
            $current = $stack[-1][-1];

            # handle the case of brace pairs without commas:
            @{$group->[0]} = map { "{$_}" } @{$group->[0]} if @$group == 1;

            @$current = map {
                my $c = $_;
                map { map { $c . $_ } @$_ } @$group;
            } @$current;
        }
        else { $_ .= $1 for @$current; }
    }

    # handle the case of missing closing braces:
    while (@stack > 1) {
        my $right = pop @{$stack[-1]};
        my $sep;
        if (@{$stack[-1]}) { $sep = ',' }
        else               { $sep = '{'; pop @stack }
        $current = $stack[-1][-1];
        @$current = map {
            my $c = $_;
            map { $c . $sep . $_ } @$right;
        } @$current;
    }

    return @$current;
}
