main()
{
  int n=5,d=3;
int z= fact(n,d);
print('$n factorial of degree $d is $z');
for(var j=1;j<=5;j++)
{
  print('first 10 numbers of degree $j :');
  for(var i=1;i<=10;i++)
  {
    int z=fact(i,j);
 print('$z');
}
  print('\n');
}
}

int fact(int a,int b)
{

  if(a<=b||a==0)
    return a;
  if(a>1)
    return a*fact((a-b),b);
}
