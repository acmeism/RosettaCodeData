let mut var07;
let mut var08: f32;
let mut var09 = 1.5;
let mut var10 = 2.5f32;
let mut var11: f32 = 5.0;
let mut var12: f64 = 5.0f64;
var07 = var11; // This line makes the compiler infer var07 should be a f32.
var08 = 3.1416f32; // Assigning to var08 after declaration
var08 = 2.7183f32; // Reassigning var08 since it can be reassigned since it is mutable.
