#include "stdlib.h"
#include "string.h"

// Declare C functions that will be used.
fn C.strdup(txt &char) &char
fn C.strcat(dest &char, src &char) &char

fn main() {
	txt_1 := "Hello World!"
	txt_2 := " Let's Wish for Peace!"
	// Memory-unsafe operations must be marked as such (unsafe {...}), or won't compile.
	unsafe {
		dup := C.strdup(txt_1.str)
		println('${cstring_to_vstring(dup)}')
		
		addto := C.strcat(dup, txt_2.str)
		println('${cstring_to_vstring(addto)}')

		// Must manually free memory or program can hang because unsafe.
		free(dup)
		free(addto)
	}
	exit(0)
}
