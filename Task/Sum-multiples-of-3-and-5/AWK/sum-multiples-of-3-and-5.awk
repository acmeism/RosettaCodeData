#!/usr/bin/awk -f
{
	n = $1-1;
	print sum(n,3)+sum(n,5)-sum(n,15);
}
function sum(n,d) {
	m = int(n/d);
	return (d*m*(m+1)/2);
}
