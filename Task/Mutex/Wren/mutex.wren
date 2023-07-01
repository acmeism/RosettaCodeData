foreign class Resource {
    // obtain a pointer to the resource when available
    construct new() {}

    // method for using the resource
    foreign doSomething()

    // signal to the host that the resource is no longer needed
    foreign release()
}

var res = Resource.new()  // wait for and obtain a lock on the resource
res.doSomething()         // use it
res.release()             // release the lock
