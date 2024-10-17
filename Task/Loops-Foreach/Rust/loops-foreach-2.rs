let mut collection = vec![1,2,3,4,5];
for mut_ref in &mut collection {
// alternatively:
// for mut_ref in collection.iter_mut() {
    *mut_ref *= 2;
    println!("{}", *mut_ref);
}

// immutable borrow
for immut_ref in &collection {
// alternatively:
// for immut_ref in collection.iter() {
    println!("{}", *immut_ref);
}
