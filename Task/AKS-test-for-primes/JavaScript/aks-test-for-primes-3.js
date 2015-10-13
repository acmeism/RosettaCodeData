function coef(n) {
 	for (var c=[1], i=0; i<n; c[0]=-c[0], i+=1) {
		c[i+1]=1; for (var j=i; j; j-=1) c[j] = c[j-1]-c[j]		
	}
	return c
}

function show(cs)	{
	var s='', n=cs.length-1
	do s += (cs[n]>0 ? ' +' : ' ') + cs[n] + (n==0 ? '' : n==1 ? 'x' :'x<sup>'+n+'</sup>'); while (n--)
	return s
}

function isPrime(n) {
	var cs=coef(n), i=n-1; while (i-- && cs[i]%n == 0);
	return i < 1
}

for (var n=0; n<=7; n++) document.write('(x-1)<sup>',n,'</sup> = ', show(coef(n)), '<br>')

document.write('<br>Primes: ');
for (var n=2; n<=50; n++) if (isPrime(n)) document.write(' ', n)
