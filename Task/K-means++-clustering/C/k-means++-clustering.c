# define	NUMBER_OF_POINTS	100000
# define	NUMBER_OF_CLUSTERS	11
# define	MAXIMUM_ITERATIONS	100
# define	RADIUS			10.0


#include <stdio.h>
#include <stdlib.h>
#include <math.h>


typedef struct {
	double	x;
	double	y;
	int		group;
} POINT;


/*-------------------------------------------------------
	gen_xy

	This function allocates a block of memory for data points,
	gives the data points random values and returns a pointer to them.
	The data points fall within a circle of the radius passed to
	the function. This does not create a uniform 2-dimensional
	distribution.
-------------------------------------------------------*/
POINT * gen_xy(int num_pts, double radius)
{
	int		i;
	double	ang, r;
	POINT * pts;

	pts = (POINT*) malloc(sizeof(POINT) * num_pts);
	
	for ( i = 0; i < num_pts; i++ ) {
		ang = 2.0 * M_PI * rand() / (RAND_MAX - 1.);
		r = radius * rand() / (RAND_MAX - 1.);
		pts[i].x = r * cos(ang);
		pts[i].y = r * sin(ang);
	}
	return pts;	
}

/*-------------------------------------------------------
	dist2

	This function returns the squared euclidean distance
	between two data points.
-------------------------------------------------------*/
double dist2(POINT * a, POINT * b)
{
	double x = a->x - b->x;
	double y = a->y - b->y;
	return x*x + y*y;
}

/*------------------------------------------------------
	nearest

  This function returns the index of the cluster centroid
  nearest to the data point passed to this function.
------------------------------------------------------*/
int nearest(POINT * pt, POINT * cent, int n_cluster)
{
	int i, clusterIndex;
	double d, min_d;

	min_d = HUGE_VAL;
	clusterIndex = pt->group;	
	for (i = 0; i < n_cluster; i++) {
		d = dist2(&cent[i], pt);
		if ( d < min_d ) {
			min_d = d;
			clusterIndex = i;
		}
	}	
	return clusterIndex;
}

/*------------------------------------------------------
	nearestDistance

  This function returns the distance of the cluster centroid
  nearest to the data point passed to this function.
------------------------------------------------------*/
double nearestDistance(POINT * pt, POINT * cent, int n_cluster)
{
	int i;
	double d, min_d;

	min_d = HUGE_VAL;
	for (i = 0; i < n_cluster; i++) {
		d = dist2(&cent[i], pt);
		if ( d < min_d ) {
			min_d = d;
		}
	}

	return min_d;
}

/*----------------------------------------------------------------------
  bisectionSearch

  This function makes a bisectional search of an array of values that are
  ordered in increasing order, and returns the index of the first element
  greater than the search value passed as a parameter.

  This code is adapted from code by Andy Allinger given to the public
  domain.

  Input:
		x	A pointer to an array of values in increasing order to be searched.
		n	The number of elements in the input array x.
		v	The search value.
  Output:
		Returns the index of the first element greater than the search value, v.
----------------------------------------------------------------------*/
int bisectionSearch(double *x, int n, double v)
{
	int il, ir, i;
	

	if (n < 1) {
		return 0;
	}
	/* If v is less than x(0) or greater than x(n-1)  */
	if (v < x[0]) {
		return 0;
	}
	else if (v > x[n-1]) {
		return n - 1;
	}
	
	/*bisection search */
	il = 0;
	ir = n - 1;

	i = (il + ir) / 2;
	while ( i != il ) {
		if (x[i] <= v) {
			il = i;
		} else {
			ir = i;
		}
		i = (il + ir) / 2;		
	}		

	if (x[i] <= v)
		i = ir;
	return i;
} /* end of bisectionSearch */

/*-------------------------------------------------------
	kppAllinger
	
	This function uses the K-Means++ method to select
	the cluster centroids.
	
	This code is adapted from code by Andy Allinger given to the
	public domain.

	Input:
		pts		A pointer to an array of data points.
		num_pts		The number of points in the pts array.
		centroids	A pointer to an array to receive the centroids.
		num_clusters	The number of clusters to be found.
	
	Output:
		centroids	A pointer to the array of centroids found.	
-------------------------------------------------------*/
void kppAllinger(POINT * pts, int num_pts, POINT * centroids,
		 int num_clusters)
{
	int j;
	int selectedIndex;
	int cluster;
	double sum;
	double d;
	double random;	
	double * cumulativeDistances;
	double * shortestDistance;

	
	cumulativeDistances = (double*) malloc(sizeof(double) * num_pts);
	shortestDistance = (double*) malloc(sizeof(double) * num_pts);	
	

	/* Pick the first cluster centroids at random. */
	selectedIndex = rand() % num_pts;
	centroids[0] = pts[ selectedIndex ];
	
	for (j = 0; j < num_pts; ++j)
		shortestDistance[j] = HUGE_VAL;	
		
	/* Select the centroids for the remaining clusters. */
	for (cluster = 1; cluster < num_clusters; cluster++) {
			
		/* For each point find its closest distance to any of
		   the previous cluster centers */
		for ( j = 0; j < num_pts; j++ ) {
			d = dist2(&pts[j], &centroids[cluster-1] );
			
			if (d < shortestDistance[j])
				shortestDistance[j] = d;
		}
		
		/* Create an array of the cumulative distances. */
		sum = 0.0;
		for (j = 0; j < num_pts; j++) {
			sum += shortestDistance[j];
			cumulativeDistances[j] = sum;
		}

		/* Select a point at random. Those with greater distances
		   have a greater probability of being selected. */
		random = (float) rand() / (float) RAND_MAX * sum;
		selectedIndex = bisectionSearch(cumulativeDistances, num_pts, random);
		
		/* assign the selected point as the center */
		centroids[cluster] = pts[selectedIndex];
	}

	/* Assign each point the index of it's nearest cluster centroid. */
	for (j = 0; j < num_pts; j++)
		pts[j].group = nearest(&pts[j], centroids, num_clusters);

	free(shortestDistance);
	free(cumulativeDistances);

	return;
}	/* end, kppAllinger */

/*-------------------------------------------------------
	kpp
	
	This function uses the K-Means++ method to select
	the cluster centroids.
-------------------------------------------------------*/
void kpp(POINT * pts, int num_pts, POINT * centroids,
		 int num_clusters)
{
	int j;
	int cluster;
	double sum;
	double * distances;

	
	distances = (double*) malloc(sizeof(double) * num_pts);

	/* Pick the first cluster centroids at random. */
	centroids[0] = pts[ rand() % num_pts ];
	
	
	/* Select the centroids for the remaining clusters. */
	for (cluster = 1; cluster < num_clusters; cluster++) {
		
		/* For each data point find the nearest centroid, save its
		   distance in the distance array, then add it to the sum of
		   total distance. */
		sum = 0.0;
		for ( j = 0; j < num_pts; j++ ) {
			distances[j] =
				nearestDistance(&pts[j], centroids, cluster);
			sum += distances[j];
		}

		/* Find a random distance within the span of the total distance. */
		sum = sum * rand() / (RAND_MAX - 1);
		
		/* Assign the centroids. the point with the largest distance
			will have a greater probability of being selected. */
		for (j = 0; j < num_pts; j++ ) {
			sum -= distances[j];
			if ( sum <= 0)
			{
				centroids[cluster] = pts[j];
				break;
			}
		}
	}

	/* Assign each observation the index of it's nearest cluster centroid. */
	for (j = 0; j < num_pts; j++)
		pts[j].group = nearest(&pts[j], centroids, num_clusters);

	free(distances);

	return;
}	/* end, kpp */


/*-------------------------------------------------------
	lloyd
	
	This function clusters the data using Lloyd's K-Means algorithm
	after selecting the intial centroids using the K-Means++
	method.
	It returns a pointer to the memory it allocates containing
	the array of cluster centroids.
-------------------------------------------------------*/
POINT * lloyd(POINT * pts, int num_pts, int num_clusters, int maxTimes)
{
	int i, clusterIndex;
	int changes;
	int acceptable = num_pts / 1000;	/* The maximum point changes acceptable. */


	if (num_clusters == 1 || num_pts <= 0 || num_clusters > num_pts )
		return 0;


	POINT * centroids = (POINT *)malloc(sizeof(POINT) * num_clusters);

	if ( maxTimes < 1 )
		maxTimes = 1;

/*	Assign initial clustering randomly using the Random Partition method
	for (i = 0; i < num_pts; i++ ) {
		pts[i].group = i % num_clusters;
	}
*/

	/* or use the k-Means++ method */

/* Original version
	kpp(pts, num_pts, centroids, num_clusters);
*/
	/* Faster Allinger version */
	kppAllinger(pts, num_pts, centroids, num_clusters);

	do {
		/* Calculate the centroid of each cluster.
		  ----------------------------------------*/
		
		/* Initialize the x, y and cluster totals. */
		for ( i = 0; i < num_clusters; i++ ) {
			centroids[i].group = 0;		/* used to count the cluster members. */
			centroids[i].x = 0;			/* used for x value totals. */
			centroids[i].y = 0;			/* used for y value totals. */
		}
		
		/* Add each observation's x and y to its cluster total. */
		for (i = 0; i < num_pts; i++) {
			clusterIndex = pts[i].group;
			centroids[clusterIndex].group++;
			centroids[clusterIndex].x += pts[i].x;
			centroids[clusterIndex].y += pts[i].y;
		}
		
		/* Divide each cluster's x and y totals by its number of data points. */
		for ( i = 0; i < num_clusters; i++ ) {
			centroids[i].x /= centroids[i].group;
			centroids[i].y /= centroids[i].group;
		}

		/* Find each data point's nearest centroid */
		changes = 0;
		for ( i = 0; i < num_pts; i++ ) {
			clusterIndex = nearest(&pts[i], centroids, num_clusters);
			if (clusterIndex != pts[i].group) {
				pts[i].group = clusterIndex;
				changes++;
			}
		}
	
		maxTimes--;
	} while ((changes > acceptable) && (maxTimes > 0));

	/* Set each centroid's group index */
	for ( i = 0; i < num_clusters; i++ )
		centroids[i].group = i;

	return centroids;
}	/* end, lloyd */

/*-------------------------------------------------------
	print_eps

	this function prints the results.
-------------------------------------------------------*/
void print_eps(POINT * pts, int num_pts, POINT * centroids, int num_clusters)
{
#	define W 400
#	define H 400

	int i, j;
	double min_x, max_x, min_y, max_y, scale, cx, cy;
	double *colors = (double *) malloc(sizeof(double) * num_clusters * 3);

	for (i = 0; i < num_clusters; i++) {
		colors[3*i + 0] = (3 * (i + 1) % 11)/11.;
		colors[3*i + 1] = (7 * i % 11)/11.;
		colors[3*i + 2] = (9 * i % 11)/11.;
	}

	max_x = max_y = - HUGE_VAL;
	min_x = min_y = HUGE_VAL;
	for (j = 0; j < num_pts; j++) {
		if (max_x < pts[j].x) max_x = pts[j].x;
		if (min_x > pts[j].x) min_x = pts[j].x;
		if (max_y < pts[j].y) max_y = pts[j].y;
		if (min_y > pts[j].y) min_y = pts[j].y;
	}

	scale = W / (max_x - min_x);
	if (scale > H / (max_y - min_y))
		scale = H / (max_y - min_y);
	cx = (max_x + min_x) / 2;
	cy = (max_y + min_y) / 2;

	printf("%%!PS-Adobe-3.0\n%%%%BoundingBox: -5 -5 %d %d\n", W + 10, H + 10);
	printf( "/l {rlineto} def /m {rmoveto} def\n"
		"/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def\n"
		"/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath "
		"	gsave 1 setgray fill grestore gsave 3 setlinewidth"
		" 1 setgray stroke grestore 0 setgray stroke }def\n"
	);


	for (i = 0; i < num_clusters; i++) {
		printf("%g %g %g setrgbcolor\n",
			colors[3*i], colors[3*i + 1], colors[3*i + 2]);

		for (j = 0; j < num_pts; j++) {
			if (pts[j].group != i) continue;
			printf("%.3f %.3f c\n",
				(pts[j].x - cx) * scale + W / 2,
				(pts[j].y - cy) * scale + H / 2);
		}
		printf("\n0 setgray %g %g s\n",
			(centroids[i].x - cx) * scale + W / 2,
			(centroids[i].y - cy) * scale + H / 2);
	}
	printf("\n%%%%EOF");

	free(colors);

	return;
}	/* end print_eps */

/*-------------------------------------------------------
	main
-------------------------------------------------------*/
int main()
{
	int		num_pts = NUMBER_OF_POINTS;
	int		num_clusters = NUMBER_OF_CLUSTERS;
	int		maxTimes = MAXIMUM_ITERATIONS;
	double	radius = RADIUS;
	POINT * pts;
	POINT * centroids;

	/* Generate the observations */
	pts = gen_xy(num_pts, radius);

	/* Cluster using the Lloyd algorithm and K-Means++ initial centroids. */
	centroids = lloyd(pts, num_pts, num_clusters, maxTimes);

	/* Print the results */
	print_eps(pts, num_pts, centroids, num_clusters);

	free(pts);
	free(centroids);

	return 0;
}
