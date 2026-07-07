module rosettacode;

import std::io;

fn int main(String[] args)
{
  // Either of these options work:
	while (true) io::printn("SPAM");
	
  for (;;) io::printn("SPAM");
	
  do
	{
		io::printn("SPAM");
	} while (1);

	return 0;
}
