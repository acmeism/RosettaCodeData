foo 1,2           # as list operator
foo(1,2)          # as named function
foo.(1,2)         # as named function, explicit postfix
$ref(1,2)         # as object invocation (must be hard ref)
$ref.(1,2)        # as object invocation, explicit postfix
1.$foo: 2         # as pseudo-method meaning $foo(1,2) (hard ref only)
1.$foo(2)         # as pseudo-method meaning $foo(1,2) (hard ref only)
1.&foo: 2         # as pseudo-method meaning &foo(1,2) (is hard foo)
1.&foo(2)         # as pseudo-method meaning &foo(1,2) (is hard foo)
1.foo: 2          # as method via dispatcher
1.foo(2)          # as method via dispatcher
1."$name"(2)      # as method via dispatcher, symbolic
1 + 2             # as operator to infix:<+> function
