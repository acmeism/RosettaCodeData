    sub foo() { fail "oops" }
    my $failure = foo;
    say "Called foo";
    say "foo not true" unless $failure;
    say "foo not defined" unless $failure.defined;
    say "incremented foo" if $failure++; # exception
