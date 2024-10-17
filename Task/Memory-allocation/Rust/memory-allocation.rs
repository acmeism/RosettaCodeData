// we have to use `unsafe` here because
// we will be dereferencing a raw pointer
unsafe {
    use std::alloc::{Layout, alloc, dealloc};
    // define a layout of a block of memory
    let int_layout = Layout::new::<i32>();

    // memory is allocated here
    let ptr = alloc(int_layout);

    // let us point to some data
    *ptr = 123;
    assert_eq!(*ptr, 123);

    // deallocate `ptr` with associated layout `int_layout`
    dealloc(ptr, int_layout);
}
