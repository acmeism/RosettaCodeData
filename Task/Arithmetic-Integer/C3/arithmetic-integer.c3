module rosettacode;

import std::io, std::os;

fn int main(String[] args)
{
	if (args.len < 3) os::exit(1);

	int? a = string::to_integer{int}(args[1]);
	if (catch err = a)
	{
		io::eprintfn("%s\n", err);
		os::exit(1);
	}

	int? b = string::to_integer{int}(args[2]);
	if (catch err = b)
	{
		io::eprintfn("%s\n", err);
		os::exit(1);
	}

	if (b == 0) os::exit(2);

	io::printfn("a + b = %d\n", a + b)!!;
	io::printfn("a - b = %d\n", a - b)!!;
	io::printfn("a * b = %d\n", a * b)!!;
	io::printfn("a / b = %d\n", a / b)!!;
	io::printfn("a %% b = %d\n", a % b)!!;
	return 0;
}
