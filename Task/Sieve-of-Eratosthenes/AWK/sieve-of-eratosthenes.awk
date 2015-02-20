# usage:  gawk  -v n=101  -f sieve.awk

function sieve(n) { # print n,":"
	for(i=2; i<=n;      i++) a[i]=1;
	for(i=2; i<=sqrt(n);i++) for(j=2;j<=n;j++) a[i*j]=0;
	for(i=2; i<=n;      i++) if(a[i]) printf i" "
	print ""
}

BEGIN	{ print "Sieve of Eratosthenes:"
	  if(n>1) sieve(n)
	}

	{ n=$1+0 }
n<2	{ exit }
	{ sieve(n) }

END	{ print "Bye!" }
