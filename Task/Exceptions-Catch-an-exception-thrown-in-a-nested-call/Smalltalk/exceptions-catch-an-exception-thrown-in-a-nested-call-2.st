st> Foo new foo
'Call to bar was aborted by exception U0'
Object: Foo new "<-0x4c9a7960>" error: An exception has occurred
U1(Exception)>>signal (ExcHandling.st:254)
Foo>>baz (catch_exception.st:32)
Foo>>bar (catch_exception.st:27)
optimized [] in Foo>>foo (catch_exception.st:19)
BlockClosure>>on:do: (BlkClosure.st:193)
Foo>>foo (catch_exception.st:20)
UndefinedObject>>executeStatements (a String:1)
nil
