var amount=100, coin=[1,5,10,25]
var t=[1]; for (t[amount]=0, a=1; a<amount; a++) t[a]=0 // initialise t[0..amount]=[1,0,...,0]
for (var i=0, e=coin.length; i<e; i++)
	for (var ci=coin[i], a=ci; a<=amount; a++)
		t[a] += t[a-ci]
document.write( t[amount] )
