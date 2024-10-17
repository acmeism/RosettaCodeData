// This function will only be compiled if we are compiling on Linux
#[cfg(target_os = "linux")]
fn running_linux() {
    println!("This is linux");
}
#[cfg(not(target_os = "linux"))]
fn running_linux() {
    println!("This is not linux");
}

// If we are on linux, we must be using glibc
#[cfg_attr(target_os = "linux", target_env = "gnu")]
// We must either be compiling for ARM or on a little endian machine that doesn't have 32-bit pointers pointers, on a
// UNIX like OS and only if we are doing a test build
#[cfg(all(
        any(target_arch = "arm", target_endian = "little"),
        not(target_pointer_width = "32"),
        unix,
        test
        ))]
fn highly_specific_function() {}
