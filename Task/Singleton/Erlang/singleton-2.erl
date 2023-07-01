1> singleton:get().
not_set
2> singleton:set(apple).
ok
3> singleton:get().
{ok,apple}
4> singleton:set("Pear").
ok
5> singleton:get().
{ok,"Pear"}
6> singleton:set(42).
ok
7> singleton:get().
{ok,42}
