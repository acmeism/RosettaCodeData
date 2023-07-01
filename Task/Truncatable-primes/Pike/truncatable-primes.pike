bool is_trunc_prime(int p, string direction)
{
    while(p) {
	if( !p->probably_prime_p() )
	    return false;
	if(direction == "l")
	    p = (int)p->digits()[1..];
	else
	    p = (int)p->digits()[..<1];
    }
    return true;
}

void main()
{
    bool ltp_found, rtp_found;
    for(int prime = 10->pow(6); prime--; prime > 0) {
	if( !ltp_found && is_trunc_prime(prime, "l") ) {
	    ltp_found = true;
	    write("Largest LTP: %d\n", prime);
	}
	if( !rtp_found && is_trunc_prime(prime, "r") ) {
	    rtp_found = true;
	    write("Largest RTP: %d\n", prime);
	}
	if(ltp_found && rtp_found)
	    break;
    }
}
