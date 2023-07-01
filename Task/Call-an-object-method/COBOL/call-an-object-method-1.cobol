*> INVOKE
INVOKE FooClass "someMethod" RETURNING bar        *> Factory object
INVOKE foo-instance "anotherMethod" RETURNING bar *> Instance object

*> Inline method invocation
MOVE FooClass::"someMethod" TO bar        *> Factory object
MOVE foo-instance::"anotherMethod" TO bar *> Instance object
