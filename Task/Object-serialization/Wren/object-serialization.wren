import "./json" for JSON
import "io" for File, FileFlags

class Entity {
    construct new(name) {
        _name = name
    }

    name { _name }

    // JSON representation
    toString { "{\"name\": \"%(_name)\"}" }

    // mimics the JSON output
    print() { System.print(this.toString.replace("\"", "")) }

    serialize(fileName) {
        var o = JSON.parse(this.toString)
        File.openWithFlags(fileName, FileFlags.writeOnly) { |file|
            file.writeBytes("%(o)\n")
        }
    }
}

class Person is Entity {
    construct new(name, age) {
        super(name)
        _age = age
    }

    // JSON representation
    toString { "{\"name\": \"%(name)\", \"age\": \"%(_age)\"}" }

    // mimics the JSON output
    print() { System.print(this.toString.replace("\"", "")) }

    serialize(fileName) {
        var o = JSON.parse(this.toString)
        File.openWithFlags(fileName, FileFlags.writeOnly) { |file|
            file.writeBytes("%(o)\n")
        }
    }
}

// create file for serialization
var fileName = "objects.dat"
var file = File.create(fileName)
file.close()

System.print("Calling print methods gives:")

var e = Entity.new("John")
e.print()
e.serialize(fileName)

var p = Person.new("Fred", 35)
p.print()
p.serialize(fileName)

System.print("\nContents of objects.dat are:")
System.print(File.read(fileName))
