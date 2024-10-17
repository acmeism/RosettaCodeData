extern crate libc;

//c function that returns the sum of two integers
extern {
    fn add_input(in1: libc::c_int, in2: libc::c_int) -> libc::c_int;
}

fn main() {
    let (in1, in2) = (5, 4);
    let output = unsafe {
        add_input(in1, in2) };
    assert!( (output == (in1 + in2) ),"Error in sum calculation") ;
}
