use std::{mem,ptr};

fn main() {
    let mut data: i32;

    // Rust does not allow us to use uninitialized memory but the STL provides an `unsafe`
    // function to override this protection.
    unsafe {data = mem::uninitialized()}

    // Construct a raw pointer (perfectly safe)
    let address = &mut data as *mut _;

    unsafe {ptr::write(address, 5)}
    println!("{0:p}: {0}", &data);

    unsafe {ptr::write(address, 6)}
    println!("{0:p}: {0}", &data);

}
