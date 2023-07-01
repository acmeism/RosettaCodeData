type MyClass(init) =      // constructor with one argument: init
  let mutable var = init  // a private instance variable
  member x.Method() =     // a simple method
    var <- var + 1
    printfn "%d" var

// create an instance and use it
let myObject = new MyClass(42)
myObject.Method()
