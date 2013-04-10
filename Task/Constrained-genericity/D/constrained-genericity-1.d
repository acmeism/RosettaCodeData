template IsEdible(T) {
    enum IsEdible = is(typeof(T.eat()));
}

struct FoodBox(T) if (IsEdible!T) {
    T[] food;
    alias food this;
}

struct Carrot {
    void eat() {}
}

static struct Car {}

void main() {
    FoodBox!Carrot carrotsBox; // OK
    carrotsBox ~= Carrot();    // Adds a carrot

    //FoodBox!Car carsBox;     // Not allowed
}
