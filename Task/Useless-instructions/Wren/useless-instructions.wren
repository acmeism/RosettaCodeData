var uselessFunc = Fn.new { |uselessParam|  // required but never used
    if (true) {
        // do something
    } else {
        System.print("Never called")
    }

    for (e in []) {
        System.print("Never called")
    }

    while (false) {
        System.print("Never called")
    }

    System.write("")  // no visible effect

    return // redundant as function would return 'naturally' anyway
}

class NotCompletelyUseless {
    /*
       On the face of it this class is useless because:
       (1) it has no methods
       (2) although it inherits from Object, static methods are not inherited

       However, it's not in fact completely useless because:
       (3) a Class object is still created and accessible
       (4) it can be used as an abstract base class for other classes
    */
}

uselessFunc.call(0)
System.print(NotCompletelyUseless) // prints the string representation of the Class object
