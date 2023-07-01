//func.call() /* invalid, can't call func before its declared */

var func = Fn.new { System.print("func has been called.") }

func.call() // fine

//C.init() /* not OK, as C is null at this point */

class C {
    static init()   { method() } // fine even though 'method' not yet declared
    static method() { System.print("method has been called.") }
}

C.init() // fine
