function Animal() {
    // ...
}

function Dog() {
    // ...
}
Dog.prototype = new Animal();

function Cat() {
    // ...
}
Cat.prototype = new Animal();

function Collie() {
    // ...
}
Collie.prototype = new Dog();

function Lab() {
    // ...
}
Lab.prototype = new Dog();

Animal.prototype.speak = function() {print("an animal makes a sound")};

var lab = new Lab();
lab.speak();  // shows "an animal makes a sound"
