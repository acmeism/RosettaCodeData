#charset utf8
void main()
{
    string s = upper_case("ἀρχῇ ß");
    string out = sprintf("Upper: %s\nLower: %s\n",
			 s, lower_case(s));
    write( string_to_utf8(out) );
}
