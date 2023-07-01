/* call_foreign_language_function.wren */

class C {
    foreign static strdup(s)
}

var s = "Hello World!"
System.print(C.strdup(s))
