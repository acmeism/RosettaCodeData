foo @args         # as list operator
foo(@args)        # as named function
foo.(@args)       # as named function, explicit postfix
$ref(@args)       # as object invocation (must be hard ref)
$ref.(@args)      # as object invocation, explicit postfix
1.$foo: @args     # as pseudo-method meaning $foo(1,@args) (hard ref)
1.$foo(@args)     # as pseudo-method meaning $foo(1,@args) (hard ref)
1.&foo: @args     # as pseudo-method meaning &foo(1,@args)
1.&foo(@args)     # as pseudo-method meaning &foo(1,@args)
1.foo: @args      # as method via dispatcher
1.foo(@args)      # as method via dispatcher
1."$name"(@args)  # as method via dispatcher, symbolic
@args X @blargs   # as list infix operator to infix:<X>
