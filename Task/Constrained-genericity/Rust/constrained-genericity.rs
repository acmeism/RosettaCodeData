// This declares the "Eatable" constraint. It could contain no function.
trait Eatable {
    fn eat();
}

// This declares the generic "FoodBox" type,
// whose parameter must satisfy the "Eatable" constraint.
// The objects of this type contain a vector of eatable objects.
struct FoodBox<T: Eatable> {
    _data: Vec<T>,
}

// This implements the functions associated with the "FoodBox" type.
// This statement is not required, but here it is used
// to declare a handy "new" constructor.
impl<T: Eatable> FoodBox<T> {
    fn new() -> FoodBox<T> {
        FoodBox::<T> { _data: Vec::<T>::new() }
    }
}

// This declares a simple type.
struct Banana {}

// This makes the "Banana" type satisfy the "Eatable" constraint.
// For that, every declaration inside the declaration of "Eatable"
// must be implemented here.
impl Eatable for Banana {
    fn eat() {}
}

// This makes also the primitive "char" type satisfy the "Eatable" constraint.
impl Eatable for char {
    fn eat() {}
}

fn main() {
    // This instantiate a "FoodBox" parameterized by the "Banana" type.
    // It is allowed as "Banana" implements "Eatable".
    let _fb1 = FoodBox::<Banana>::new();

    // This instantiate a "FoodBox" parameterized by the "char" type.
    // It is allowed, as "char" implements "Eatable".
    let _fb2 = FoodBox::<char>::new();

    // This instantiate a "FoodBox" parameterized by the "bool" type.
    // It is NOT allowed, as "bool" does not implement "Eatable".
    //let _fb3 = FoodBox::<bool>::new();
}
