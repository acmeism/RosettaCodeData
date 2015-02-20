/*28th August, 2012
Abhishek Ghosh

Uses C99 specified complex.h, complex datatype has to be defined and operation provided if used on non-C99 compilers */

#include<stdlib.h>
#include<stdio.h>
#include<complex.h>

typedef struct
{
  int rows, cols;
  complex **z;
} matrix;

matrix
transpose (matrix a)
{
  int i, j;
  matrix b;

  b.rows = a.cols;
  b.cols = a.rows;

  b.z = malloc (b.rows * sizeof (complex *));

  for (i = 0; i < b.rows; i++)
    {
      b.z[i] = malloc (b.cols * sizeof (complex));
      for (j = 0; j < b.cols; j++)
        {
          b.z[i][j] = conj (a.z[j][i]);
        }
    }

  return b;
}

int
isHermitian (matrix a)
{
  int i, j;
  matrix b = transpose (a);

  if (b.rows == a.rows && b.cols == a.cols)
    {
      for (i = 0; i < b.rows; i++)
        {
          for (j = 0; j < b.cols; j++)
            {
              if (b.z[i][j] != a.z[i][j])
                return 0;
            }
        }
    }

  else
    return 0;

  return 1;
}

matrix
multiply (matrix a, matrix b)
{
  matrix c;
  int i, j;

  if (a.cols == b.rows)
    {
      c.rows = a.rows;
      c.cols = b.cols;

      c.z = malloc (c.rows * (sizeof (complex *)));

      for (i = 0; i < c.rows; i++)
        {
          c.z[i] = malloc (c.cols * sizeof (complex));
          c.z[i][j] = 0 + 0 * I;
          for (j = 0; j < b.cols; j++)
            {
              c.z[i][j] += a.z[i][j] * b.z[j][i];
            }
        }

    }

  return c;
}

int
isNormal (matrix a)
{
  int i, j;
  matrix a_ah, ah_a;

  if (a.rows != a.cols)
    return 0;

  a_ah = multiply (a, transpose (a));
  ah_a = multiply (transpose (a), a);

  for (i = 0; i < a.rows; i++)
    {
      for (j = 0; j < a.cols; j++)
        {
          if (a_ah.z[i][j] != ah_a.z[i][j])
            return 0;
        }
    }

  return 1;
}

int
isUnitary (matrix a)
{
  matrix b;
  int i, j;
  if (isNormal (a) == 1)
    {
      b = multiply (a, transpose(a));

      for (i = 0; i < b.rows; i++)
        {
          for (j = 0; j < b.cols; j++)
            {
              if ((i == j && b.z[i][j] != 1) || (i != j && b.z[i][j] != 0))
                return 0;
            }
        }
      return 1;
    }
  return 0;
}


int
main ()
{
  complex z = 3 + 4 * I;
  matrix a, aT;
  int i, j;
  printf ("Enter rows and columns :");
  scanf ("%d%d", &a.rows, &a.cols);

  a.z = malloc (a.rows * sizeof (complex *));
  printf ("Randomly Generated Complex Matrix A is : ");
  for (i = 0; i < a.rows; i++)
    {
      printf ("\n");
      a.z[i] = malloc (a.cols * sizeof (complex));
      for (j = 0; j < a.cols; j++)
        {
          a.z[i][j] = rand () % 10 + rand () % 10 * I;
          printf ("\t%f + %fi", creal (a.z[i][j]), cimag (a.z[i][j]));
        }
    }

  aT = transpose (a);

  printf ("\n\nTranspose of Complex Matrix A is : ");
  for (i = 0; i < aT.rows; i++)
    {
      printf ("\n");
      aT.z[i] = malloc (aT.cols * sizeof (complex));
      for (j = 0; j < aT.cols; j++)
        {
          aT.z[i][j] = rand () % 10 + rand () % 10 * I;
          printf ("\t%f + %fi", creal (aT.z[i][j]), cimag (aT.z[i][j]));
        }
    }

  printf ("\n\nComplex Matrix A %s hermitian",
          isHermitian (a) == 1 ? "is" : "is not");
  printf ("\n\nComplex Matrix A %s unitary",
          isUnitary (a) == 1 ? "is" : "is not");
  printf ("\n\nComplex Matrix A %s normal",
          isNormal (a) == 1 ? "is" : "is not");



  return 0;
}
