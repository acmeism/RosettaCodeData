    // The following will never panic!
    println!("{:?}", 65_537u32.checked_mul(65_537));    // None
    println!("{:?}", 65_537u32.saturating_mul(65_537)); // 4294967295
    println!("{:?}", 65_537u32.wrapping_mul(65_537));   // 131073

    // These will never panic! either
    println!("{:?}", 65_537i32.checked_mul(65_537));     // None
    println!("{:?}", 65_537i32.saturating_mul(65_537));  // 2147483647
    println!("{:?}", 65_537i32.wrapping_mul(-65_537));   // -131073
