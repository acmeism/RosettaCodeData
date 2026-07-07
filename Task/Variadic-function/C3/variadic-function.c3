module rosettacode;

import std::io;

// Typed variadic arguments like most modern languages.
fn void print_strings(String ...strs)
{
	foreach (String s : strs) io::printn(s);
}

// Untyped variadic arguments, which can also be used for C interop.
macro void things(...)
{
	$for var $i = 0; $i < $vaarg.len; $i++:
		io::printn($vaarg[$i]);
	$endfor
}

fn int main(String[] args)
{
	things("Hello world", 15, 3.14);
	io::printn();
	String[] strs = { "Hello", "world", "John", "Doe", "foo", "bar", "baz" };
	print_strings(...strs);
	return 0;
}
