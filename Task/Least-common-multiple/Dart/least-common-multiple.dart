main() {
	int x=8;
  int y=12;
int z= gcd(x,y);
  var lcm=(x*y)/z;
  print('$lcm');
  }

int gcd(int a,int b)
{
  if(b==0)
    return a;
  if(b!=0)
    return gcd(b,a%b);
}
