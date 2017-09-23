import 'dart:math';
void main()
{
  int y=5;
  int max=11,min=1;
  var x= new Random();
  x=x.nextInt(max-min);
  if (y==x)
    print("WON");
  else
    print('Try Again');
}
