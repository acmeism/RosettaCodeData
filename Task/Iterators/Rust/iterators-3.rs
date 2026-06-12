fn example() -> Option<()> {
    let days_of_week = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
    ];

    let colors =
        std::collections::LinkedList::from(["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]);

    println!("All elements:");

    // for loops in Rust are always "range for" loops.
    // for loops require the underlying type to implement IntoIterator such as
    // other iterators, smart pointers, channel receivers, monads, ranges, collections, and slices.
    // each value is yielded by calling next() on our iterator, which the for loop does for us.
    for day in days_of_week {
        print!("{day} ");
    }
    println!();

    // for_each() is a function implemented by Iterator that emulates the behavior of the for loop,
    // except you can't use break, continue, or any constructs that rely on them such as '?'.
    // for_each() will end the iterator chain, so if you are looking to continue using the iterator,
    // consider using inspect().
    colors.iter().for_each(|color| print!("{color} "));
    println!("\n");

    println!("First, fourth, and fifth:");

    // arrays allow random access with indices, and that's the recommended way to get the following
    // values, but we can get close to those semantics with next() and nth().
    // using either of these functions also advances the iterator forwards, you cannot go backwards
    // without creating a new iterator; so we'll create a new one for each line below.
    let first = days_of_week.iter().next()?;
    let fourth = days_of_week.iter().nth(3)?;
    let fifth = days_of_week.iter().nth(4)?;
    println!("{first} {fourth} {fifth} ");

    // with linked-list, we _have_ to use these Iterator methods to traverse the collection.
    // here we reuse the same iterator to get the values we want, which is much more efficient,
    // especially for this data structure whose traversal always starts from either end anyway.
    let mut color_iter = colors.iter();
    let first = color_iter.next()?;
    let fourth = color_iter.nth(2)?;
    let fifth = color_iter.next()?;
    println!("{first} {fourth} {fifth} \n");

    println!("Reverse first, fourth, and fifth:");

    // iterators that implement DoubleEndedIterator can call rev() for easy iterator chaining.
    // here, we're using range adaptors; methods defined by the Iterator trait that return types
    // which also implement the Iterator trait, allowing us to chain them together.
    // iterators are lazy, and do nothing unless consumed.
    for (i, day) in days_of_week.iter().rev().take(5).enumerate() {
        if [0, 3, 4].contains(&i) {
            print!("{day} ");
        }
    }
    println!();

    // iterators that implement DoubleEndedIterator can also yield values from the end directly.
    let mut color_iter = colors.iter();
    let first = color_iter.next_back()?;
    let fourth = color_iter.nth_back(2)?;
    let fifth = color_iter.next_back()?;
    println!("{first} {fourth} {fifth} ");

    // double-ended iterators stop yielding values when both ends meet; so to end this example,
    // let's intentionally iterate past where the two ends intersect.
    // our iterator here knows how many elements are left because it implements ExactSizedIterator.
    assert_eq!(1, color_iter.len());
    color_iter.nth(1).map(|_| ())
}

fn main() {
    assert_eq!(None, example());
}
