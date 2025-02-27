/* an array of ten ints */
int a[10];

/* a 2D-array of floats with three rows and two columns */
float b[3][2];
/*
  these would be ordered in memory as
  b[0][0] b[0][1] b[1][0] b[1][1] b[2][0] b[2][1]

  for example:
*/
b[0][0] = 1.0;
b[0][1] = 2.0;
b[1][0] = 3.0;
b[1][1] = 4.0;
b[2][0] = 5.0;
b[2][1] = 6.0;
/*
now these would be stored in memory as:

+----+----+----+----+----+----+
| 1.0| 2.0| 3.0| 4.0| 5.0| 6.0|
+----+----+----+----+----+----+

*/


/* a 3D-array of chars */
char c[4][5][6];

/* etc. */
