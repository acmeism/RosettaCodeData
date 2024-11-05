/* This script could convert base10 to any base number system, & in any symbol-set
charset can be anything, any symbols, but the frist one should be the zero symbol */
string  charset = "01";

string int2chr(integer int) {
// convert integer to unsigned charset
    integer base = llStringLength(charset);
    string  out;
    integer j;
    if(int < 0) {
        j = ((0x7FFFFFFF & int) % base) - (0x80000000 % base);
        integer k = j % base;
        int = (j / base) + ((0x7FFFFFFF & int) / base) - (0x80000000 / base);
        out = llGetSubString(charset, k, k);
    }
    do
        out = llGetSubString(charset, j = int % base, j) + out;
    while(int /= base);
    return out;
}

integer chr2int(string chr) {
// convert unsigned charset to integer
    integer base = llStringLength(charset);
    integer i = -llStringLength(chr);
    integer j = 0;
    while(i)
        j = (j * base) + llSubStringIndex(charset, llGetSubString(chr, i, i++));
    return j;
}

string pad (string input, integer width)
{
    integer i=llStringLength(input);
    string zero=llGetSubString(charset,0,0);
//first symbol of charset should be for zero
// add padding if necessary

    while(width>i)
    {
    i=i+1;
    input=zero+input; // prepend string and loop
    }
// take away padding if necessary

    while(width<i)
// do this if padding length is less than input
    {  i=i-1;
    if((llGetSubString(input, 0, 0))==zero)
        {
// eat first leading bit if it's a zero symbol
   input=llDeleteSubString(input,0,0);
//equivalent to input=llGetSubString(input,1,-1);
        }
    else{width=i;}
// to break loop stop if not a leading zero
    }
return input;
}

default
{   // Default state is where script starts
    state_entry()
	{
        integer a = 42;
        llOwnerSay((string)a);
        string output = int2chr(a); // dec to bin
		llOwnerSay(output);
        output=pad(output,10);  // add padding
        llOwnerSay(output);
        output=pad(output,0); // take away padding
        llOwnerSay(output);
       llOwnerSay( (string)chr2int(output) ); // bin to dec
    }
}
