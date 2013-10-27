grammar Markov {
    token TOP {
        ^ [^^ [<rule> | <comment>] $$ [\n|$]]* $
        { make $<rule>>>.ast }
    }
    token comment {
        <before ^^> '#' \N*
        { make Nil }
    }
    token ws {
        [' '|\t]*
    }
    rule rule {
        <before ^^>$<pattern>=[\N+?] '->'
        $<terminal>=[\.]?$<replacement>=[\N*]
        { make {:pattern($<pattern>.Str),
                :replacement($<replacement>.Str),
                :terminal($<terminal>.Str eq ".")} }
    }
}

sub run(:$ruleset, :$start_value, :$verbose?) {
    my $value = $start_value;
    my @rules = Markov.parse($ruleset).ast.list;
    loop {
        my $beginning = $value;
        for @rules {
            my $prev = $value;
            $value = $value.subst(.<pattern>, .<replacement>);
            say $value if $verbose && $value ne $prev;
            return $value if .<terminal>;
            last if $value ne $prev;
        }
        last if $value eq $beginning;
    }
    return $value;
}

multi sub MAIN(Bool :$verbose?) {
    my @rulefiles = dir.grep(/rules.+/).sort;
    for @rulefiles -> $rulefile {
        my $testfile = $rulefile.subst("rules", "test");
        my $start_value = (try slurp($testfile).trim-trailing)
                          // prompt("please give a start value: ");

        my $ruleset = slurp($rulefile);
        say $start_value.perl();
        say run(:$ruleset, :$start_value, :$verbose).perl;
        say;
    }
}

multi sub MAIN(Str $rulefile where *.IO.f, Str $input where *.IO.f, Bool :$verbose?) {
    my $ruleset = slurp($rulefile);
    my $start_value = slurp($input).trim-trailing;
    say "starting with $start_value.perl()";
    say run(:$ruleset, :$start_value, :$verbose).perl;
}

multi sub MAIN(Str $rulefile where *.IO.f, *@pieces, Bool :$verbose?) {
    my $ruleset = slurp($rulefile);
    my $start_value = @pieces.join(" ");
    say "starting with $start_value.perl()";
    say run(:$ruleset, :$start_value, :$verbose).perl;
}
