import "meta" for Meta

var genericClass = Fn.new { |cname, fname|
    var s1 = "class %(cname) {\n"
    var s2 = "construct new(%(fname)){\n_%(fname) = %(fname)\n}\n"
    var s3 = "%(fname) { _%(fname) }\n"
    var s4 = "}\nreturn %(cname)\n"
    return Meta.compile(s1 + s2 + s3 + s4).call() // returns the Class object
}

var CFoo = genericClass.call("Foo", "bar")
var foo = CFoo.new(10)
System.print([foo.bar, foo.type])
