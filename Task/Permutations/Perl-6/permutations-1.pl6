sub postfix:<!>(@a) {
    @a == 1 ?? [@a] !!
    gather for @a -> $a {
        take [ $a, @$_ ] for @a.grep(none $a)!
    }
}

.say for <a b c>!
