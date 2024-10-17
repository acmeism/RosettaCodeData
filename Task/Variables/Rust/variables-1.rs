let var01; // The compiler will infer the type or the compiler will ask for type annotations if the type can't be inferred
let var02: u32; // The compiler will check if a value is assigned to var02 before being used
let var03 = 5; // The compiler will infer the type or it will fallback to i32
let var04 = 5u8; // Initialization to unsigned 8 bit (u8) number 5
let var05: i8 = 5; // Type annotation + Initialization
let var06: u8 = 5u8; // Type annotation + Initialization
var01 = var05; // This line makes the compiler infer var01 should be a signed 8 bit number (i8).
var02 = 9u32; // Assigning to var02 after declaration
