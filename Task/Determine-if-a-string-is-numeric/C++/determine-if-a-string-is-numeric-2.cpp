bool isNumeric( const char* pszInput, int nNumberBase )
{
	string base = "0123456789ABCDEF";
	string input = pszInput;

	return (input.find_first_not_of(base.substr(0, nNumberBase)) == string::npos);
}
