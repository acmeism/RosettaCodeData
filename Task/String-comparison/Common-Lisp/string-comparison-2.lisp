> (string-equal "foo" "FOo")
T
> (string-not-equal "foo" "FOO")
NIL
> (string-greaterp "foo" "Foo")
NIL
> (string-lessp "BAR" "foo")
0
> (string-not-greaterp "foo" "Foo")
3
> (string-not-lessp "baz" "bAr")
2
