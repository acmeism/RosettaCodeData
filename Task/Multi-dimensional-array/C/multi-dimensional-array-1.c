/*Single dimensional array of integers*/
int a[10];

/*2-dimensional array, also called matrix of floating point numbers.
This matrix has 3 rows and 2 columns.*/

float b[3][2];

/*3-dimensional array ( Cube ? Cuboid ? Lattice ?) of characters*/

char c[4][5][6];

/*4-dimensional array (Hypercube ?) of doubles*/

double d[6][7][8][9];

/*Note that the right most number in the [] is required, all the others may be omitted.
Thus this is ok : */

int e[][3];

/*But this is not*/

float f[5][4][];

/*But why bother with all those numbers ? You can also write :*/
int *g;

/*And for a matrix*/
float **h;

/*or if you want to show off*/
double **i[];

/*you get the idea*/

char **j[][5];
