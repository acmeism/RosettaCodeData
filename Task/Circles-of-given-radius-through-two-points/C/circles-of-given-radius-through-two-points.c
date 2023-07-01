#include<stdio.h>
#include<math.h>

typedef struct{
	double x,y;
	}point;
	
double distance(point p1,point p2)
{
	return sqrt((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y));
}
	
void findCircles(point p1,point p2,double radius)
{
	double separation = distance(p1,p2),mirrorDistance;
	
	if(separation == 0.0)
	{
		radius == 0.0 ? printf("\nNo circles can be drawn through (%.4f,%.4f)",p1.x,p1.y):
							 printf("\nInfinitely many circles can be drawn through (%.4f,%.4f)",p1.x,p1.y);
	}
	
	else if(separation == 2*radius)
	{
		printf("\nGiven points are opposite ends of a diameter of the circle with center (%.4f,%.4f) and radius %.4f",(p1.x+p2.x)/2,(p1.y+p2.y)/2,radius);
	}
	
	else if(separation > 2*radius)
	{
		printf("\nGiven points are farther away from each other than a diameter of a circle with radius %.4f",radius);
	}
	
	else
	{
		mirrorDistance =sqrt(pow(radius,2) - pow(separation/2,2));
		
		printf("\nTwo circles are possible.");
		printf("\nCircle C1 with center (%.4f,%.4f), radius %.4f and Circle C2 with center (%.4f,%.4f), radius %.4f",(p1.x+p2.x)/2 + mirrorDistance*(p1.y-p2.y)/separation,(p1.y+p2.y)/2 + mirrorDistance*(p2.x-p1.x)/separation,radius,(p1.x+p2.x)/2 - mirrorDistance*(p1.y-p2.y)/separation,(p1.y+p2.y)/2 - mirrorDistance*(p2.x-p1.x)/separation,radius);
	}
}

int main()
{
    int i;

    point cases[] = 	
    {	{0.1234, 0.9876},    {0.8765, 0.2345},
	{0.0000, 2.0000},    {0.0000, 0.0000},
	{0.1234, 0.9876},    {0.1234, 0.9876},
	{0.1234, 0.9876},    {0.8765, 0.2345},
	{0.1234, 0.9876},    {0.1234, 0.9876}
    };

    double radii[] = {2.0,1.0,2.0,0.5,0.0};

    for(i=0;i<5;i++)
    {	
	printf("\nCase %d)",i+1);
	findCircles(cases[2*i],cases[2*i+1],radii[i]);
    }

    return 0;
}
