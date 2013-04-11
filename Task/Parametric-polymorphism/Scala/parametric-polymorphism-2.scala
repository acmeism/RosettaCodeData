class Employee(val name: String)
class Manager(name: String) extends Employee(name)

val t = Tree(new Manager("PHB"), None, None)
val t2: Tree[Employee] = t
