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
System.print("List of properties available for object 'c':")
for (property in c.type.attributes.self["instance_properties"]) System.print(property.key)
