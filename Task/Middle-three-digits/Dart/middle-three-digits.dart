import'dart:math';
  int length(int x)
  {
    int i,y;
  for(i=0;;i++)
  {
    y=pow(10,i);
    if(x%y==x)
      break;
  }
    return i;
  }
 int middle(int x,int l)
  {
 int a=(x/10)-((x%10)/10);
  int b=a%(pow(10,l-2));
  int l2=length(b);
      if(l2==3)
      {
        return b;
      }
    if(l2!=3)
      {
        return middle(b,l2);
      }
  return 0;
  }


main()
{
  int x=-100,y;
  if(x<0)
 x=-x;
  int l=length(x);
  if(l.isEven||x<100)
  {print('error');}
    if(l==3)
  {print('$x');}

  if(l.isOdd&& x>100)
  {
   y=middle(x,l);
  print('$y');
  }
}
