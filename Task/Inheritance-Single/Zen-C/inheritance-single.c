trait Animal {
    fn make_noise(self);
}

struct Dog { name: string; }

impl Animal for Dog {
    fn make_noise(self) { println "{.name} says, woof!"; }
}

struct Cat { name: string; }

impl Animal for Cat {
    fn make_noise(self) { println "{.name} says, meow!" }
}

struct Lab { use dog: Dog; }

struct Collie { use dog: Dog; }

fn main() {
    let prince = Lab{dog: Dog{name: "Prince"}};
    prince.dog.make_noise();

    let lassie = Collie{dog: Dog{name: "Lassie"}};
    lassie.dog.make_noise();

    let fluffy = Cat{name: "Fluffy"};
    fluffy.make_noise();
}
