let number = 0xfe
let base   = 16

// Except toString which is from ContestKit everything
// else used here is defined in Swift Standard Library
print(number.toString(base: base).characters
    .map { char in Int(String(char), radix: base)! }
    .reduce(0, combine: +))
