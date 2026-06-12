#include <fstream>
#include <iostream>
#include <sstream>
#include <streambuf>
#include <string>

#include <stdlib.h>

using namespace std;

// a function to handle fatal errors
void fatal_error(string errtext, char *argv[])
{
	cout << "%" << errtext << endl;
	cout << "usage: " << argv[0] << " [filename.cp]" << endl;
	exit(1);
}

// functions to trim strings
// (http://www.martinbroadhurst.com/how-to-trim-a-stdstring.html)
string& ltrim(string& str, const string& chars = "\t\n\v\f\r ")
{
	str.erase(0, str.find_first_not_of(chars));
	return str;
}
string& rtrim(string& str, const string& chars = "\t\n\v\f\r ")
{
	str.erase(str.find_last_not_of(chars) + 1);
	return str;
}
string& trim(string& str, const string& chars = "\t\n\v\f\r ")
{
	return ltrim(rtrim(str, chars), chars);
}

int main(int argc, char *argv[])
{
	// get a filename from the command line and read the file in
	string fname = "";
	string source = "";
	try
	{
		fname = argv[1];
		ifstream t(fname);

		t.seekg(0, ios::end);
		source.reserve(t.tellg());
		t.seekg(0, ios::beg);

		source.assign((istreambuf_iterator<char>(t)), istreambuf_iterator<char>());
	}
	catch(const exception& e)
	{
		fatal_error("error while trying to read from specified file", argv);
	}

	// a variable to represent the 'clipboard'
	string clipboard = "";

	// loop over the lines that were read
	int loc = 0;
	string remaining = source;
	string line = "";
	string command = "";
	stringstream ss;
	while(remaining.find("\n") != string::npos)
	{
		// check which command is on this line
		line = remaining.substr(0, remaining.find("\n"));
		command = trim(line);
		remaining = remaining.substr(remaining.find("\n") + 1);
		
		try
		{
			if(line == "Copy")
			{
				line = remaining.substr(0, remaining.find("\n"));
				remaining = remaining.substr(remaining.find("\n") + 1);
				clipboard += line;
			}
			else if(line == "CopyFile")
			{
				line = remaining.substr(0, remaining.find("\n"));
				remaining = remaining.substr(remaining.find("\n") + 1);
				if(line == "TheF*ckingCode")
					clipboard += source;
				else
				{
					string filetext = "";
					ifstream t(line);

					t.seekg(0, ios::end);
					filetext.reserve(t.tellg());
					t.seekg(0, ios::beg);

					filetext.assign((istreambuf_iterator<char>(t)), istreambuf_iterator<char>());
					clipboard += filetext;
				}
			}
			else if(line == "Duplicate")
			{
				line = remaining.substr(0, remaining.find("\n"));
				remaining = remaining.substr(remaining.find("\n") + 1);
				int amount = stoi(line);
				string origClipboard = clipboard;
				for(int i = 0; i < amount - 1; i++) {
					clipboard += origClipboard;
				}
			}
			else if(line == "Pasta!")
			{
				cout << clipboard << endl;
				return 0;
			}
			else
			{
				ss << (loc + 1);
				fatal_error("unknown command '" + command + "' encounter on line " + ss.str(), argv);
			}
		}
		catch(const exception& e)
		{
			ss << (loc + 1);
			fatal_error("error while executing command '" + command + "' on line " + ss.str(), argv);
		}

		// increment past the command and the next line
		loc += 2;
	}

	// return in case we never hit a 'Pasta!' statement
	return 0;
}
