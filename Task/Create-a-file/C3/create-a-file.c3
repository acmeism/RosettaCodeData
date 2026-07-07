module rosettacode;

import std::io, std::os;

fn int main(String[] args)
{
	File? file = file::open("output.txt", "w");
	if (catch err = file)
	{
		io::eprintfn("%s", err);
		os::exit(1);
	}
	// From here onwards, file has the type 'File' because
	// we have already checked for any file errors, and now
	// the 'option' is removed from the type and we can use it
	// normally.
	defer (void)file.close(); // cast to void to ignore errors.
	// work with the opened file here...

	return 0;
}
