let address: usize = 0x7ffc8f303130;
unsafe {
    let val = *(address as *const usize);
    println!("value at {}: {:?}", address, val);
}
