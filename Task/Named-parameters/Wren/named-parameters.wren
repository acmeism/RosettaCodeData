var printName = Fn.new { |name|
    if (!(name is Map && name["first"] != null && name["last"] !=  null)) {
        Fiber.abort("Argument must be a map with keys \"first\" and \"last\"")
    }
    System.print("%(name["first"]) %(name["last"])")
}

printName.call({"first": "Abraham", "last": "Lincoln"}) // normal order
printName.call({"last": "Trump", "first": "Donald"})  // reverse order
printName.call({"forename": "Boris", "lastname": "Johnson"}) // wrong parameter names
