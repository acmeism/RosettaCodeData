// Version 1.2.31

import java.io.Serializable
import java.io.ByteArrayOutputStream
import java.io.ByteArrayInputStream
import java.io.ObjectOutputStream
import java.io.ObjectInputStream

fun <T : Serializable> deepCopy(obj: T?): T? {
    if (obj == null) return null
    val baos = ByteArrayOutputStream()
    val oos  = ObjectOutputStream(baos)
    oos.writeObject(obj)
    oos.close()
    val bais = ByteArrayInputStream(baos.toByteArray())
    val ois  = ObjectInputStream(bais)
    @Suppress("unchecked_cast")
    return ois.readObject() as T
}

class Person(
    val name: String,
    var age: Int,
    val sex: Char,
    var income: Double,
    var partner: Person?
) : Serializable

fun printDetails(p1: Person, p2: Person?, p3: Person, p4: Person?) {
    with (p3) {
        println("Name    : $name")
        println("Age     : $age")
        println("Sex     : $sex")
        println("Income  : $income")
        if (p4 == null) {
            println("Partner : None")
        }
        else {
            println("Partner :-")
            with (p4) {
                println("  Name   : $name")
                println("  Age    : $age")
                println("  Sex    : $sex")
                println("  Income : $income")
            }
        }
        println("\nSame person as original '$name' == ${p1 === p3}")
        if (p4 != null) {
            println("Same person as original '${p2!!.name}' == ${p2 === p4}")
        }
    }
    println()
}

fun main(args: Array<String>) {
    var p1 = Person("John", 35, 'M', 50000.0, null)
    val p2 = Person("Jane", 32, 'F', 25000.0, p1)
    p1.partner = p2
    var p3 = deepCopy(p1)
    val p4 = p3!!.partner
    printDetails(p1, p2, p3, p4)

    println("..or, say, after 2 years have elapsed:-\n")
    with (p1) {
        age = 37
        income = 55000.0
        partner = null
    }
    p3 = deepCopy(p1)
    printDetails(p1, null, p3!!, null)
}
