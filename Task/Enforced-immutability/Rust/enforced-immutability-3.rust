let mut x = 4;
let y = &x;
*y += 2 // Raises compiler error. Even though x is mutable, y is an immutable reference.
let y = &mut x;
*y += 2// Works
// Note that though y is now a mutable reference, y itself is still immutable e.g.
let mut z = 5;
let y = &mut z; // Raises compiler error because y is already assigned to '&mut x'
