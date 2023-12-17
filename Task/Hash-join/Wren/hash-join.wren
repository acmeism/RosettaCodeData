import "./fmt" for Fmt

class A {
    construct new(age, name) {
        _age = age
        _name = name
    }

    age  { _age  }
    name { _name }
}

class B {
    construct new(character, nemesis) {
        _character = character
        _nemesis = nemesis
    }

    character { _character }
    nemesis   { _nemesis   }
}

var tableA = [
    A.new(27, "Jonah"),  A.new(18, "Alan"), A.new(28, "Glory"),
    A.new(18, "Popeye"), A.new(28, "Alan")
]
var tableB = [
    B.new("Jonah", "Whales"), B.new("Jonah", "Spiders"), B.new("Alan", "Ghosts"),
    B.new("Alan", "Zombies"), B.new("Glory", "Buffy")
]
var h = {}
var i = 0
for (a in tableA) {
    var n = h[a.name]
    if (n) {
        n.add(i)
    } else {
        h[a.name] = [i]
    }
    i = i + 1
}

System.print("Age  Name   Character Nemesis")
System.print("---  -----  --------- -------")
for (b in tableB) {
    var c = h[b.character]
    if (c) {
        for (i in c) {
            var t = tableA[i]
            Fmt.print("$3d  $-5s  $-9s $s", t.age, t.name, b.character, b.nemesis)
        }
    }
}
