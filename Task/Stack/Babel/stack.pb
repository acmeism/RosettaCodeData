main :
    { (1 2 3) foo set     -- foo = (1 2 3)
    4 foo push            -- foo = (1 2 3 4)
    0 foo unshift         -- foo = (0 1 2 3 4)
    foo pop               -- foo = (0 1 2 3)
    foo shift             -- foo = (1 2 3)
    check_foo
    { foo pop } 4 times   -- Pops too many times, but this is OK and Babel won't complain
    check_foo }

empty? : nil?   -- just aliases 'empty?' to the built-in operator 'nil?'

check_foo! :
    { "foo is "
    {foo empty?) {nil} {"not " .} ifte
    "empty" .
    cr << }
