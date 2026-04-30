// allocate 2 uninitialized bytes & return a reference
mut p := unsafe { malloc(2) }

// p[0] = `h` // Error: pointer indexing is only allowed in `unsafe` blocks
unsafe {
p[0] = `h` // OK
p[1] = `i`
}
// p++ // Error: pointer arithmetic is only allowed in `unsafe` blocks
unsafe { p++ } // OK
if *p == `i` { println((*p).ascii_str()) } else { println("`*p` is not `i`") }
unsafe { free(p) }
exit(0)
