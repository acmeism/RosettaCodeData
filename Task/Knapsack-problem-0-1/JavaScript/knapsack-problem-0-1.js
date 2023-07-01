<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>KNAPSACK 22 JavaScript</title> </head> <body> <noscript>Vkluch JS</noscript>

https://jdoodle.com/h/2Ut
	
rextester.com/BQYV50962

<script>

var n=22; G=400; a = Math.pow(2,n+1); // KNAPSACKj.js
var dec, i, h, k, max, m, s;
var L=[n], C=[n], j=[n], q=[a], d=[a]; e=[a];

document.write("<br><br>#  Kol Cena<br>")
document.write("#  Amo Price<br><br>")

L=[ 9,13,153,50,15,68,27,39,23,52,11,32,24,48,73,42,43,22,7,18,4,30 ]
C=[ 150,35,200,160,60,45,60,40,30,10,70,30,15,10,40,70,75,80,20,12,50,10 ]

for (i=0; i<n; i++)
{ //  L[i]=1+Math.floor(Math.random()*3)
  //  C[i]=10+Math.floor(Math.random()*9);
  j[i]=0;
  document.write( (i+1) +" "+ L[i] +" "+ C[i] +"<br>")
}
for (i=0; i<a; i++) { q[i]=0; d[i]=0;}
document.write("<br>")

document.write("Mx Kol St-st Schifr<br>")
document.write("Mx Amo Price Cipher<br>")

for (h = a-1; h>(a-1)/2; h--)
{ dec=h; e[h]=""

while (dec > 0)
{ s = Math.floor(dec % 2);
  e[h] = s + e[h]; dec = Math.floor(dec/2);
}

if (e[h] == "") {e[h] = "0";}
e[h]= e[h].substr(1, e[h].length-1);

for (k=0; k<n; k++)
{ j[k] = Number(e[h].substr(k,1));
  q[h]=q[h]+j[k]*C[k];
  d[h]=d[h]+L[k]*j[k];
}

// if (d[h] <= G)
// document.write("<br>"+ G +" "+ d[h] +" "+ q[h] +" "+ e[h])

} document.write("<br>")

max=0; m=1;
for (i=0; i<a; i++)
{ if (d[i]<=G && q[i]>max){ max=q[i]; m=i;}
}

document.write("<br>"+ d[m] +" "+ q[m] +" "+ e[m] +"<br><br>")

document.write("Mx St-st Schifr<br>")
document.write("Mx Price Cipher<br><br>")

</script>

</body> </html>
