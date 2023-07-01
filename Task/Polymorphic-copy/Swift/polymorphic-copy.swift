class T {
  required init() { } // constructor used in polymorphic initialization must be "required"
  func identify() {
    println("I am a genuine T")
  }
  func copy() -> T {
    let newObj : T = self.dynamicType() // call an appropriate constructor here
    // then copy data into newObj as appropriate here
    // make sure to use "self.dynamicType(...)" and
    // not "T(...)" to make it polymorphic
    return newObj
  }
}

class S : T {
  override func identify()  {
    println("I am an S")
  }
}

let original : T = S()
let another : T = original.copy()
println(original === another) // prints "false" (i.e. they are different objects)
another.identify() // prints "I am an S"
