template<typename T> concept Eatable = requires(T t) { t.eat(); };

struct Potato { void eat(); };

struct Brick {};

template<Eatable T> class FoodBox {};

int main() {
    FoodBox<Potato> lunch{};
    // Following leads to compile-time error
    //FoodBox<Brick> practical_joke{};
}
