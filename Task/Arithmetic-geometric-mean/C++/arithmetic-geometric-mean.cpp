#include<bits/stdc++.h>
using namespace std;
#define _cin	ios_base::sync_with_stdio(0);	cin.tie(0);
#define rep(a, b)	for(ll i =a;i<=b;++i)

double agm(double a, double g)		//ARITHMETIC GEOMETRIC MEAN
{	double epsilon = 1.0E-16,a1,g1;
	if(a*g<0.0)
	{	cout<<"Couldn't find arithmetic-geometric mean of these numbers\n";
		exit(1);
	}
	while(fabs(a-g)>epsilon)
	{	a1 = (a+g)/2.0;
		g1 = sqrt(a*g);
		a = a1;
		g = g1;
	}
	return a;
}

int main()
{	_cin;    //fast input-output
	double x, y;
	cout<<"Enter X and Y: ";	//Enter two numbers
	cin>>x>>y;
	cout<<"\nThe Arithmetic-Geometric Mean of "<<x<<" and "<<y<<" is "<<agm(x, y);
return 0;
}
