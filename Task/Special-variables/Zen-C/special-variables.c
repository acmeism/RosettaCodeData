struct Person {
    name: string;
    age: int;
}

impl Person {
    // Constructor.
    fn new(name: string, age: int) -> Self {
        return Person{ name: name, age: age };
    }

    // Instance method.
    fn change_name(self, new_name: string) {
        self.name = new_name;
    }

    // Instance method which is automatically called by string interpolation.
    fn to_string(self) -> string {
        return "Person: name = {self.name}, age = {self.age}";
    }
}

fn main() {
    let p = Person::new("fred", 40);
    println "{p}";
    p.change_name("george");
    println "{p}\n";

    // Prints Hello 3 times without requiring a 'normal' control variable.
    for _ in 0..3 {
        println "Hello";
    }
}
