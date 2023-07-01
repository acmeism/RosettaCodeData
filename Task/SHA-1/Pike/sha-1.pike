string input = "Rosetta Code";
string out = Crypto.SHA1.hash(input);
write( String.string2hex(out) +"\n");
