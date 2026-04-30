struct Check {
    mut:
    methods map[string]fn()  // map names to functions
}

fn (mut chk Check) call_method(name string) {
    if name in chk.methods { chk.methods[name]() } // call existing method
    else {
        println("You are calling a method that does not exist!")
        println("New Method Name: '${name}'") // dynamically add new method name
        chk.methods[name] = fn () { println("Hello from the new method!") } // what new method will do
        println("We defined the new method!")
    }
}

fn main() {
    mut chk := Check{}
    chk.call_method("anyMethodThatDoesNotExist")
    chk.call_method("anyMethodThatDoesNotExist")
}
