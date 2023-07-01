bool is_unprimeable(int i)
{
    string s = i->digits();
    for(int offset; offset < sizeof(s); offset++) {
	foreach("0123456789"/1, string repl) {
	    array chars = s/1;
	    chars[offset] = repl;
	    int testme = (int)(chars*"");
	    if( testme->probably_prime_p() )
		return false;
	}
    }
    return true;
}

void main()
{
    int i, count;
    array unprimes = ({});
    mapping first_enders = ([]); // first unprimeable ending with each digit
    while(sizeof(first_enders) != 10) {
	i++;
	if( is_unprimeable(i) ) {
	    count++;
	    unprimes += ({ i });
	    string last_digit = i->digits()[<0..];
	    if( !first_enders[last_digit] )
		first_enders[last_digit] = i;
	}
	werror("%d\r", i); // Progress output
    }

    write("First 35 unprimeables: %s\n\n", (array(string))unprimes[0..34]*" ");
    write("The 600th unprimeable is %d\n\n", unprimes[599]);
    write("The first unprimeable number that ends in\n");
    foreach(sort(indices(first_enders)), string e) {
	write("  %s is: %9d\n", e, first_enders[e]);
    }
}
