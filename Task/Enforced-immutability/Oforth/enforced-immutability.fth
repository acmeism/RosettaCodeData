Object Class new: MyClass(a, b)

MyClass method: setA(value)  value := a ;
MyClass method: setB(value)  value := b ;

MyClass method: initialize(v, w)  self setA(v) self setB(w) ;

MyClass new(1, 2)                // OK : An immutable object
MyClass new(1, 2) setA(4)        // KO : An immutable object can't be updated after initialization
MyClass new(ListBuffer new, 12)  // KO : Not an immutable value.
ListBuffer new Constant new: T   // KO : A constant cannot be mutable.
Channel new send(ListBuffer new) // KO : A mutable object can't be sent into a channel.
