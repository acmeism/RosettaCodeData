// Declare the class "/foo"
foo
    // Everything inside the indented block is relative to the parent, "/foo" here.
    // Instance variable "bar", with a default value of 0
    // Here, var/bar is relative to /foo, thus it becomes "/foo/var/bar" ultimately.
    var/bar = 0

    // The "New" proc is the constructor.
    New()
        // Constructor code.

    // Declares a proc called "Baz" on /foo
    proc/baz()
        // Do things.

// Instantiation code.
// Overriding /client/New() means it is ran when a client connects.
/client/New()
    ..()
    var/foo/x = new /foo()
    x.bar = 10 // Assign to the instance variable.
    x.baz() // Call "baz" on our instance.
