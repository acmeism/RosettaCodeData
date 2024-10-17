// version 1.2.0

import java.io.*

open class Entity(val name: String = "Entity"): Serializable {
    override fun toString() = name

    companion object {
        val serialVersionUID = 3504465751164822571L
    }
}

class Person(name: String = "Brian"): Entity(name), Serializable {
    companion object {
        val serialVersionUID = -9170445713373959735L
    }
}

fun main(args: Array<String>) {
    val instance1 = Person()
    println(instance1)

    val instance2 = Entity()
    println(instance2)

    // serialize
    try {
        val out = ObjectOutputStream(FileOutputStream("objects.dat"))
        out.writeObject(instance1)
        out.writeObject(instance2)
        out.close()
        println("Serialized...")
    }
    catch (e: IOException) {
        println("Error occurred whilst serializing")
        System.exit(1)
    }

    // deserialize
    try {
        val inp = ObjectInputStream(FileInputStream("objects.dat"))
        val readObject1 = inp.readObject()
        val readObject2 = inp.readObject()
        inp.close()
        println("Deserialized...")
        println(readObject1)
        println(readObject2)
    }
    catch (e: IOException) {
        println("Error occurred whilst deserializing")
        System.exit(1)
    }
    catch (e: ClassNotFoundException) {
        println("Unknown class for deserialized object")
        System.exit(1)
    }
}
