package main

main :: proc() {
  i : int = 42
  ip : ^int = &i                  // Get address of variable

  address := uintptr(0xdeadf00d)
  ip2 := cast(^int)address        // Set the address
}
