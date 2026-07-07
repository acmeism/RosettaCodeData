module rosettacode;

import std::io;

fn int main(String[] args)
{
	String s1 = "Hello world";
	// uses 'mem' which is the default heap allocator:
	String s2 = s1.copy(mem);
	// Uses 'tmem' which is the default temporary allocator:
	String s3 = s1.tcopy();

	io::printfn("s1 = %s\ns2 = %s\ns3 = %s", s1, s2, s3);
	return 0;
}
