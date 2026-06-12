main() {
  var a = [1,2,3,4,5];
  var s=25,c=0;
  var z=(a.length*(a.length-1))/2;
   for (var x = 0; x < a.length; x++) {
   print(a[x]);
   }
 for (var x = 0; x < a.length; x++) {
    for(var y=x+1;y< a.length; y++)
    {
      if(a[x]+a[y]==s)
      {
        print([a[x],a[y]]);
        break;
      }
      else
      {
       c++;
      }
    }
 }
if(c==z)
{
 print("such pair doesn't exist");
}
}


