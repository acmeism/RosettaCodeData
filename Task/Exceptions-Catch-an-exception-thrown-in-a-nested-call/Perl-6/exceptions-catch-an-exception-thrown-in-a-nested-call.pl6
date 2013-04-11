sub foo() {
    for 0..1 -> $i {
        bar $i;
        CATCH {
            when /U0/ { say "Function foo caught exception U0" }
        }
    }
}

sub bar($i) { baz $i }

sub baz($i) { die "U$i" }

foo;
