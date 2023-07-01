string input = "Rosetta code";
string out = Crypto.SHA256.hash(input);
write( String.string2hex(out) +"\n");
