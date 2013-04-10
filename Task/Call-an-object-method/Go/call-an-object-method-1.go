type Foo int // some custom type

// method on the type itself; can be called on that type or its pointer
func (self Foo) ValueMethod(x int) { }

// method on the pointer to the type; can be called on pointers
func (self *Foo) PointerMethod(x int) { }


var myValue Foo
var myPointer *Foo = new(Foo)

// Calling value method on value
myValue.ValueMethod(someParameter)
// Calling pointer method on pointer
myPointer.PointerMethod(someParameter)

// Value methods can always be called on pointers
// equivalent to (*myPointer).ValueMethod(someParameter)
myPointer.ValueMethod(someParameter)

// In a special case, pointer methods can be called on values that are addressable (i.e. lvalues)
// equivalent to (&myValue).PointerMethod(someParameter)
myValue.PointerMethod(someParameter)

// You can get the method out of the type as a function, and then explicitly call it on the object
Foo.ValueMethod(myValue, someParameter)
(*Foo).PointerMethod(myPointer, someParameter)
(*Foo).ValueMethod(myPointer, someParameter)
