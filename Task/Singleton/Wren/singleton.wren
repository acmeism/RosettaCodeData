class Singleton {
    // Returns the singleton. If it hasn't been created, creates it first.
    static instance { __instance == null ? __instance = Singleton.new_() : __instance }

    // Private constructor.
    construct new_() {}

    // instance method
    speak() { System.print("I'm a singleton.") }

}

var s1 = Singleton.instance
var s2 = Singleton.instance
System.print("s1 and s2 are same object = %(Object.same(s1, s2))")
s1.speak() // call instance method
