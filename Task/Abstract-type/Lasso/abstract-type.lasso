define abstract_trait => trait {
    require get(index::integer)

    provide first()  => .get(1)
    provide second() => .get(2)
    provide third()  => .get(3)
    provide fourth() => .get(4)
}

define my_type => type {
    parent array
    trait { import abstract_trait }

    public onCreate(...) => ..onCreate(:#rest)
}

local(test) = my_type('a','b','c','d','e')
#test->first  + "\n"
#test->second + "\n"
#test->third  + "\n"
#test->fourth + "\n"
