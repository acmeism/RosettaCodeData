// func.call() /* invalid, can't call func before its defined */

var func = Fn.new { System.print("func has been called.") }

func.call() // fine

//C.init() /* not OK, as C is null at this point */

class C {
    static init()   { method() } // fine even though 'method' not yet defined
    static method() { System.print("method has been called.") }
}

C.init() // fine

/* Although this function is recursive, there is no need for a forward
   declaration as it is top-level and begins with a capital letter. */
var Fib = Fn.new { |n|
    if (n < 2) return n
    return Fib.call(n-1) + Fib.call(n-2) // Fib already visible here
}

System.print(Fib.call(8)) // fine
