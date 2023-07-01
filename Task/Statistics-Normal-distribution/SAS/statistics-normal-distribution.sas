data test;
n=100000;
twopi=2*constant('pi');
do i=1 to n;
	u=ranuni(0);
	v=ranuni(0);
	r=sqrt(-2*log(u));
	x=r*cos(twopi*v);
	y=r*sin(twopi*v);
	z=rannor(0);
	output;
end;
keep x y z;

proc means mean stddev;

proc univariate;
histogram /normal;

run;

/*
Variable            Mean         Std Dev
----------------------------------------
x             -0.0052720       0.9988467
y            0.000023995       1.0019996
z              0.0012857       1.0056536
*/
