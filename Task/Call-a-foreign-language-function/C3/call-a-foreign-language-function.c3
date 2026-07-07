module rosettacode;

import std::io;

extern fn void puts(char*);

fn int main(String[] args)
{
	// This will call the "puts"
	// function in the C stdlib.
  // more info can be found here: https://c3-lang.org/language-common/cinterop
	puts("Hello, world!");
	return 0;
}
