unsafe {
    *(0x7ffc8f303130 as *mut usize) = 1;
    // Note that this invokes undefined behavior if 0x7ffc8f303130 is uninitialized. In that case, std::ptr::write should be used.
    std::ptr::write(0x7ffc8f303130 as *mut usize, 1);
}
