// Anonymous
enum { APPLE, BANANA, CHERRY }

// Named (commonlu used enum in D) (uint)
enum Fruits1 { apple, banana, cherry }

// Named with specified values (uint)
enum Fruits2 { apple = 0, banana = 10, cherry = 20 }

// Named, typed and with specified values
enum Fruits3 : ubyte { apple = 0, banana = 100, cherry = 200 }

void main() {
    static assert(CHERRY == 2);
    int f1 = Fruits2.banana; // No error
    // Fruits2 f2 = 1; // Compilation error
}
