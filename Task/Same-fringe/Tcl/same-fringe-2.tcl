# Make some trees to compare...
struct::tree t1 deserialize {
    root {} {}
      a 0 {}
        d 3 {}
        e 3 {}
      b 0 {}
      c 0 {}
}
struct::tree t2 deserialize {
    root {} {}
      a 0 {}
        d 3 {}
        e 3 {}
      b 0 {}
      cc 0 {}
}

# Print the boolean result of doing the comparison
puts [samefringe t1 t2]
