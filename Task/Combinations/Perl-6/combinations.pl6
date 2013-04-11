proto combine (Int, @) {*}

multi combine (0,  @)  { [] }
multi combine ($,  []) { () }
multi combine ($n, [$head, *@tail]) {
    map( { [$head, @^others] },
            combine($n-1, @tail) ),
    combine($n, @tail);
}

.say for combine(3, [^5]);
