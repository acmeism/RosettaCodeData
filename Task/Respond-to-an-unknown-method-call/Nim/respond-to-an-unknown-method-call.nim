{.experimental:"dotOperators".}
from strutils import join

type Foo = object

proc qux(f:Foo) = echo "called qux"

#for nicer output
func quoteStrings[T](x:T):string = (when T is string: "\"" & x & "\"" else: $x)

#dot operator catches all unmatched calls on Foo
template `.()`(f:Foo,field:untyped,args:varargs[string,quoteStrings]):untyped =
  echo "tried to call method '" & astToStr(`field`) & (if `args`.len > 0: "' with args: " & args.join(", ") else: "'")

let f = Foo()
f.bar()
#f.bar  #error: undeclared field
f.baz("hi",5)
f.qux()
f.qux("nope")
