interface IEdible { void eat(); }

struct FoodBox(T : IEdible) {
    T[] food;
    alias food this;
}

class Carrot : IEdible {
    void eat() {}
}

class Car {}

void main() {
    FoodBox!Carrot carrotBox; // OK
    //FoodBox!Car carBox;     // Not allowed
}
