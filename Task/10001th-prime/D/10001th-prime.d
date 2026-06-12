import std.stdio;

int isprime( int p ) {
    int i;
	
    if(p==2) return 1;

    if(!(p%2)) return 0;
	
    for(i=3; i*i<=p; i+=2) {
       if(!(p%i)) return 0;
    }
	
    return 1;
}

int prime( int n ) {
	
    if(n==1) return 2;
	
    int p, pn=1;
	
    for(p=3;pn<n;p+=2) {
        if(isprime(p)) pn++;
    }
	
    return p-2;
}

void main()
{
	writeln(prime(10_001));
}
