let s: pointer = nil

{.experimental: "notnil".}
let ns: pointer not nil = nil # Compile time error
