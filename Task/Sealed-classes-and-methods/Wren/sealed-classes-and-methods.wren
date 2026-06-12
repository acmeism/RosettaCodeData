class Parent {
    construct new(name, age) {
        _name = name
        _age  = age
    }

    watchMovie() {
        if (this.type != Parent && _age < 15) {
            System.print("Sorry, %(_name), you are too young to watch the movie.")
        } else {
            System.print("%(_name) is watching the movie...")
        }
    }
}

class Child is Parent {
    construct new(name, age) {
        super(name, age)
    }
}

var p = Parent.new("Donald", 42)
p.watchMovie()

var c1 = Child.new("Lisa", 18)
var c2 = Child.new("Fred", 10)
c1.watchMovie()
c2.watchMovie()
