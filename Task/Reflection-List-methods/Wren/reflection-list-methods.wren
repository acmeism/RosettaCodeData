#! instance_methods(m, n, o)
#! instance_properties(p, q, r)
class C {
   construct new() {}

   m() {}

   n() {}

   o() {}

   p {}

   q {}

   r {}
}

var c = C.new() // create an object of type C
System.print("List of instance methods available for object 'c':")
for (method in c.type.attributes.self["instance_methods"]) System.print(method.key)
