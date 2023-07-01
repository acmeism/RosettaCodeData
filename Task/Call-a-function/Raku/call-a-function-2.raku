foo 1             # as list operator
foo(1)            # as named function
foo.(1)           # as named function, explicit postfix
$ref(1)           # as object invocation (must be hard ref)
$ref.(1)          # as object invocation, explicit postfix
1.$foo            # as pseudo-method meaning $foo(1) (hard ref only)
1.$foo()          # as pseudo-method meaning $foo(1) (hard ref only)
1.&foo            # as pseudo-method meaning &foo(1) (is hard foo)
1.&foo()          # as pseudo-method meaning &foo(1) (is hard foo)
1.foo             # as method via dispatcher
1.foo()           # as method via dispatcher
1."$name"()       # as method via dispatcher, symbolic
+1                # as operator to prefix:<+> function
