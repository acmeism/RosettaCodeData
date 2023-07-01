>(string= "foo" "foo")
T
> (string= "foo" "FOO")
NIL
> (string/= "foo" "bar")
0
> (string/= "bar" "baz")
2
> (string/= "foo" "foo")
NIL
> (string> "foo" "Foo")
0
> (string< "foo" "Foo")
NIL
> (string>= "FOo" "Foo")
NIL
> (string<= "FOo" "Foo")
1
