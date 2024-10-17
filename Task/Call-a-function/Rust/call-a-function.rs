fn main() {
    // Rust has a lot of neat things you can do with functions: let's go over the basics first
    fn no_args() {}
    // Run function with no arguments
    no_args();

    // Calling a function with fixed number of arguments.
    // adds_one takes a 32-bit signed integer and returns a 32-bit signed integer
    fn adds_one(num: i32) -> i32 {
        // the final expression is used as the return value, though `return` may be used for early returns
        num + 1
    }
    adds_one(1);

    // Optional arguments
    // The language itself does not support optional arguments, however, you can take advantage of
    // Rust's algebraic types for this purpose
    fn prints_argument(maybe: Option<i32>) {
        match maybe {
            Some(num) => println!("{}", num),
            None => println!("No value given"),
        };
    }
    prints_argument(Some(3));
    prints_argument(None);

    // You could make this a bit more ergonomic by using Rust's Into trait
    fn prints_argument_into<I>(maybe: I)
        where I: Into<Option<i32>>
    {
        match maybe.into() {
            Some(num) => println!("{}", num),
            None => println!("No value given"),
        };
    }
    prints_argument_into(3);
    prints_argument_into(None);

    // Rust does not support functions with variable numbers of arguments. Macros fill this niche
    // (println! as used above is a macro for example)

    // Rust does not support named arguments

    // We used the no_args function above in a no-statement context

    // Using a function in an expression context
    adds_one(1) + adds_one(5); // evaluates to eight

    // Obtain the return value of a function.
    let two = adds_one(1);

    // In Rust there are no real built-in functions (save compiler intrinsics but these must be
    // manually imported)

    // In rust there are no such thing as subroutines

    // In Rust, there are three ways to pass an object to a function each of which have very important
    // distinctions when it comes to Rust's ownership model and move semantics. We may pass by
    // value, by immutable reference, or mutable reference.

    let mut v = vec![1, 2, 3, 4, 5, 6];

    // By mutable reference
    fn add_one_to_first_element(vector: &mut Vec<i32>) {
        vector[0] += 1;
    }
    add_one_to_first_element(&mut v);
    // By immutable reference
    fn print_first_element(vector: &Vec<i32>) {
        println!("{}", vector[0]);
    }
    print_first_element(&v);

    // By value
    fn consume_vector(vector: Vec<i32>) {
        // We can do whatever we want to vector here
    }
    consume_vector(v);
    // Due to Rust's move semantics, v is now inaccessible because it was moved into consume_vector
    // and was then dropped when it went out of scope

    // Partial application is not possible in rust without wrapping the function in another
    // function/closure e.g.:
    fn average(x: f64, y: f64) -> f64 {
        (x + y) / 2.0
    }
    let average_with_four = |y| average(4.0, y);
    average_with_four(2.0);


}
