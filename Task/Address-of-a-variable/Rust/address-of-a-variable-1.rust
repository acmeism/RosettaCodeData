let v1 = vec![vec![1,2,3]; 10];
println!("Original address: {:p}", &v1);
let mut v2;
// Override rust protections on reading from uninitialized memory
unsafe {v2 = mem::uninitialized();}
let addr = &mut v2 as *mut _;

// ptr::write() though it takes v1 by value, v1s destructor is not run when it goes out of
// scope, which is good since then we'd have a vector of free'd vectors
unsafe {ptr::write(addr, v1)}
println!("New address: {:p}", &v2);
