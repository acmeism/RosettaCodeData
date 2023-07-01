import 'dart:math';
  void main()
{

  int x1;
  for(x1=1;x1<1000000;x1++){
  int x;
  int i,y,y1,l1,z,l;
  double o,o1,o2,o3;
   x=pow(x1,2);
  for(i=0;;i++)
  {z=pow(10,i);
  if(x%z==x)break;}
if(i.isEven)
{
  y=pow(10,i/2);
  l=x%y;
  o=x/y;
  o=o-l/y;
  o3=o;
 for(int j=0;j<4;j++)
 {
   if(o%10==0)
     o=o/10;
   if(o%10!=0)
     break;
 }
  if(o+l==x1 ||o3+l==x1 )
     print('$x1');

}
  else

  {  y1=pow(10,i/2+0.5);
  l1=x%y1;
  o1=x/y1;
  o1=o1-l1/y1;
   o2=o1;
   for(int j=0;j<4;j++)
 {
   if(o1%10==0)
     o1=o1/10;
   else break;
 }
  if(o1+l1==x1 ||o2+l1==x1 )
    print('$x1');
  }
}
}
