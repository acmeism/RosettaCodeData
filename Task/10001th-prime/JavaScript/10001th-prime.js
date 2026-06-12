var max = 10001, n=1, p=1; var f,j,s
while (n <= max)
{ f=0; j=2; s = parseInt(Math.pow(p, 0.5))
   while (f < 1)
      { if (j >= s) f=2
        if ( p % j == 0 ) f=1
        j++
      }
   if (f != 1) n++ // { document.write(n +" "+ p +"<br>") }
   p++
}
document.write("<br>"+ (n-1) +" "+ (p-1) +"<br>" )
