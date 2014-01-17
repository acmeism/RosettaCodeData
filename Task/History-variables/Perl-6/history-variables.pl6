class HistoryVar {
    has @.history;
    has $!var handles <Str gist FETCH Numeric>;
    method STORE($val) is rw {
        push @.history, [now, $!var];
        $!var = $val;
    }
}

my $foo := HistoryVar.new;

$foo = 1;
$foo = 2;
$foo += 3;
$foo = 42;

.say for $foo.history;
say "Current value: $foo";
