class Abbreviations
{
	import std.array: split, join;
	import std.uni:toUpper;

	string[string] replaces;
	
	this(string table)
	{
		import std.ascii;
		import std.conv:parse;

		string saved;
		auto add = (string word){ if(word.length) replaces[word] = word; };

		foreach(word; table.toUpper.split)
			if(isDigit(word[0]))
			{
				for(int length=parse!int(word); length<=saved.length; ++length)
					replaces[saved[0..length]] = saved;
			} else
			{
				add(saved);
				saved = word;
			}
		add(saved);
	}

	string expand(string input) // pre-filled hashtable is used
	{
		import std.algorithm: map;
		return input.toUpper.split.map!(word => word in replaces ? replaces[word] : "*error*").join(" ");
	}
}

string table = "
   add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
   compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
   3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
   forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
   locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
   msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
   refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
   2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1";

string input = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin";
string expected = "RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT";

unittest // 'dmd -unittest ...' to activate it
{
	auto expander = new Abbreviations(table);
	assert(expander.expand(input) == expected);
	assert(expander.expand("") == "");
	assert(expander.expand("addadd") == "*error*");
}

void main()
{
	import std.stdio:writeln;

	writeln("Input : ", input);
	writeln("Output: ", new Abbreviations(table).expand(input));
}
