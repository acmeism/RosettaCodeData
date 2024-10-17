#![allow(unused_unsafe)]
extern crate libc;

use std::io::{self,Write};
use std::{mem,ffi,process};

use libc::{c_double, RTLD_NOW};

// Small macro which wraps turning a string-literal into a c-string.
// This is always safe to call, and the resulting pointer has 'static lifetime
macro_rules! to_cstr {
    ($s:expr) => {unsafe {ffi::CStr::from_bytes_with_nul_unchecked(concat!($s, "\0").as_bytes()).as_ptr()}}
}

macro_rules! from_cstr {
    ($p:expr) => {ffi::CStr::from_ptr($p).to_string_lossy().as_ref() }
}

fn main() {
    unsafe {
        let handle = libc::dlopen(to_cstr!("libm.so.6"), RTLD_NOW);

        if handle.is_null() {
            writeln!(&mut io::stderr(), "{}", from_cstr!(libc::dlerror())).unwrap();
            process::exit(1);
        }

        let extern_cos = libc::dlsym(handle, to_cstr!("cos"))
                .as_ref()
                .map(mem::transmute::<_,fn (c_double) -> c_double)
                .unwrap_or(builtin_cos);
        println!("{}", extern_cos(4.0));
    }
}

fn builtin_cos(x: c_double) -> c_double {
    x.cos()
}
