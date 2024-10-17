use std::ptr;

let p: *const i32 = ptr::null();
assert!(p.is_null());
