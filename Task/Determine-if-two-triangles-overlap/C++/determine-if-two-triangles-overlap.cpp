#include <vector>
#include <iostream>
#include <stdexcept>
using namespace std;

typedef std::pair<double, double> TriPoint;

inline double Det2D(TriPoint &p1, TriPoint &p2, TriPoint &p3)
{
	return +p1.first*(p2.second-p3.second)
		+p2.first*(p3.second-p1.second)
		+p3.first*(p1.second-p2.second);
}

void CheckTriWinding(TriPoint &p1, TriPoint &p2, TriPoint &p3, bool allowReversed)
{
	double detTri = Det2D(p1, p2, p3);
	if(detTri < 0.0)
	{
		if (allowReversed)
		{
			TriPoint a = p3;
			p3 = p2;
			p2 = a;
		}
		else throw std::runtime_error("triangle has wrong winding direction");
	}
}

bool BoundaryCollideChk(TriPoint &p1, TriPoint &p2, TriPoint &p3, double eps)
{
	return Det2D(p1, p2, p3) < eps;
}

bool BoundaryDoesntCollideChk(TriPoint &p1, TriPoint &p2, TriPoint &p3, double eps)
{
	return Det2D(p1, p2, p3) <= eps;
}

bool TriTri2D(TriPoint *t1,
	TriPoint *t2,
	double eps = 0.0, bool allowReversed = false, bool onBoundary = true)
{
	//Trangles must be expressed anti-clockwise
	CheckTriWinding(t1[0], t1[1], t1[2], allowReversed);
	CheckTriWinding(t2[0], t2[1], t2[2], allowReversed);

	bool (*chkEdge)(TriPoint &, TriPoint &, TriPoint &, double) = NULL;
	if(onBoundary) //Points on the boundary are considered as colliding
		chkEdge = BoundaryCollideChk;
	else //Points on the boundary are not considered as colliding
		chkEdge = BoundaryDoesntCollideChk;

	//For edge E of trangle 1,
	for(int i=0; i<3; i++)
	{
		int j=(i+1)%3;

		//Check all points of trangle 2 lay on the external side of the edge E. If
		//they do, the triangles do not collide.
		if (chkEdge(t1[i], t1[j], t2[0], eps) &&
			chkEdge(t1[i], t1[j], t2[1], eps) &&
			chkEdge(t1[i], t1[j], t2[2], eps))
			return false;
	}

	//For edge E of trangle 2,
	for(int i=0; i<3; i++)
	{
		int j=(i+1)%3;

		//Check all points of trangle 1 lay on the external side of the edge E. If
		//they do, the triangles do not collide.
		if (chkEdge(t2[i], t2[j], t1[0], eps) &&
			chkEdge(t2[i], t2[j], t1[1], eps) &&
			chkEdge(t2[i], t2[j], t1[2], eps))
			return false;
	}

	//The triangles collide
	return true;
}

int main()
{
	{TriPoint t1[] = {TriPoint(0,0),TriPoint(5,0),TriPoint(0,5)};
	TriPoint t2[] = {TriPoint(0,0),TriPoint(5,0),TriPoint(0,6)};
	cout << TriTri2D(t1, t2) << "," << true << endl;}

	{TriPoint t1[] = {TriPoint(0,0),TriPoint(0,5),TriPoint(5,0)};
	TriPoint t2[] = {TriPoint(0,0),TriPoint(0,5),TriPoint(5,0)};
	cout << TriTri2D(t1, t2, 0.0, true) << "," << true << endl;}

	{TriPoint t1[] = {TriPoint(0,0),TriPoint(5,0),TriPoint(0,5)};
	TriPoint t2[] = {TriPoint(-10,0),TriPoint(-5,0),TriPoint(-1,6)};
	cout << TriTri2D(t1, t2) << "," << false << endl;}

	{TriPoint t1[] = {TriPoint(0,0),TriPoint(5,0),TriPoint(2.5,5)};
	TriPoint t2[] = {TriPoint(0,4),TriPoint(2.5,-1),TriPoint(5,4)};
	cout << TriTri2D(t1, t2) << "," << true << endl;}

	{TriPoint t1[] = {TriPoint(0,0),TriPoint(1,1),TriPoint(0,2)};
	TriPoint t2[] = {TriPoint(2,1),TriPoint(3,0),TriPoint(3,2)};
	cout << TriTri2D(t1, t2) << "," << false << endl;}

	{TriPoint t1[] = {TriPoint(0,0),TriPoint(1,1),TriPoint(0,2)};
	TriPoint t2[] = {TriPoint(2,1),TriPoint(3,-2),TriPoint(3,4)};
	cout << TriTri2D(t1, t2) << "," << false << endl;}

	//Barely touching
	{TriPoint t1[] = {TriPoint(0,0),TriPoint(1,0),TriPoint(0,1)};
	TriPoint t2[] = {TriPoint(1,0),TriPoint(2,0),TriPoint(1,1)};
	cout << TriTri2D(t1, t2, 0.0, false, true) << "," << true << endl;}

	//Barely touching
	{TriPoint t1[] = {TriPoint(0,0),TriPoint(1,0),TriPoint(0,1)};
	TriPoint t2[] = {TriPoint(1,0),TriPoint(2,0),TriPoint(1,1)};
	cout << TriTri2D(t1, t2, 0.0, false, false) << "," << false << endl;}

}
