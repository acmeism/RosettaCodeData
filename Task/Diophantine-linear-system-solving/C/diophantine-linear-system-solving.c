// Subject: Solution of an m x n linear Diophantine system
//          A*x = b using LLL reduction.
// Ref.   : G. Havas, B. Majewski, K. Matthews,
//         'Extended gcd and Hermite normal form
//          algorithms via lattice basis reduction,'
//          Experimental Mathematics 7 (1998), no.2, pp.125-136
// Code   : standard C
//          compile with (gnu compiler):
//          gcc filename.c -o diophantine -lm

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdbool.h>

// ---- NOTE ----
// these next few functions are useful to allocate and free the
// array d[] and the matrices la[][] and a[][]. (Numerical Recipes in C)
// useful to deal with negative array indices.

#define NR_END 1
#define FREE_ARG char*

void nrerror(char error_text[])
/* error handler */
{
  fprintf(stderr,"Numerical Recipes run-time error...\n");
  fprintf(stderr,"%s\n",error_text);
  fprintf(stderr,"...now exiting to system...\n");
  exit(1);
}

double *dvector(long nl, long nh)
/* allocate a double vector with subscript range v[nl..nh] */
{
  double *v;

  v = (double *)calloc((size_t) ((nh - nl + 1 + NR_END)), sizeof(double));
  if (v) nrerror("allocation failure in dvector()");
  return v - nl + NR_END;
}

double **dmatrix(long nrl, long nrh, long ncl, long nch)
/* allocate a double matrix with subscript range m[nrl..nrh][ncl..nch] */
{
  long i, nrow = nrh - nrl + 1, ncol = nch - ncl + 1;
  double **m;

  /* allocate pointers to rows */
  m = (double **) calloc((size_t)((nrow + NR_END)), sizeof(double*));
  if (!m) nrerror("allocation failure 1 in matrix()");
  m += NR_END;
  m -= nrl;

  /* allocate rows and set pointers to them */
  m[nrl] = (double *) calloc((size_t)((nrow * ncol + NR_END)), sizeof(double));
  if (!m[nrl]) nrerror("allocation failure 2 in matrix()");
  m[nrl] += NR_END;
  m[nrl] -= ncl;

  for(i = nrl + 1; i <= nrh; i++) m[i] = m[i - 1] + ncol;

  /* return pointer to array of pointers to rows */
  return m;
}

void free_dvector(double *v, long nl, long nh)
/* free a double vector allocated with dvector() */
{
  free((FREE_ARG) (v + nl - NR_END));
}

void free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch)
/* free a double matrix allocated by dmatrix() */
{
  free((FREE_ARG) (m[nrl] + ncl - NR_END));
  free((FREE_ARG) (m + nrl - NR_END));
}
// ------------------------------------------------


#define echo 1
#define cls

void swap(double *a, double *b)
{
  double tmpd = *a;
  *a = *b;
  *b = tmpd;
}

void Main(int64_t sw);

// The complexity of the algorithm increases
// with alpha, as does the quality guarantee
// on the lattice basis vectors:
// alpha = aln / ald, 1/4 < alpha < 1
#define aln   80
#define ald   81
// rows & columns
int64_t m1 = 0, mn = 0, nx = 0, m = 0, n = 0;
// column indices
int64_t c1 = 0, c2 = 0;

// Gram-Schmidt coefficients
// mu_rs = lambda_rs / d_s
// Br = d_r / d_r-1
double **la = NULL, *d = NULL;
// work matrix
double **a = NULL;

//
// Part 1: driver, input and output
// ---------------------------------

int main()
{
  char *g = alloca(1024);
  int64_t i = 0, sw = 0;

  while (1)
  {
    printf("\n");
    sw = 0;
    while (1)
    {
      printf(" rows ");
      fgets(g, 1024, stdin);

      if (g[0] == '\'') {
        printf("%s\n", g);
      } else {
        break;
      }
      sw = strstr(g, "const") != NULL ? 1 : 0;
    }
    n = atof(g);
    if (n < 1) break;

    printf(" cols ");
    fgets(g, 1024, stdin);
    m = atoi(g);
    if (m < 1) {
      for (i = 1; i <= n; i++) {
        fgets(g, 1024, stdin);
      }
      continue;
    }

    // set indices and allocate
    if (sw) { sw = n - 1; n = 2; m += 2; }
    m1 = m + 1; mn = m1 + n; nx = mn + 1;
    la = dmatrix(0, m+1, 0, m+1);
    d  = dvector(-1, m+1);
    a  = dmatrix(0, m+1, 0, mn+1);

    cls;
    Main(sw);
    printf("\n");
  }

  free_dmatrix(la, 0, m+1, 0, m+1);
  free_dvector(d, -1, m+1);
  free_dmatrix(a, 0, m+1, 0, mn+1);
}

// input complex constant, read powers into A
void Inpconst(int64_t pr)
{
  int64_t r = 0, m2 = m1 + 1;
  double p = 0, q = 0, t = 0, x = 0, y = 0;
  char *g = alloca(1024);

  printf(" a + bi: ");
  fgets(g, 1024, stdin);
  g = strtok(g, "+");
  x = atof(g);
  g = strtok(NULL , "");

  printf("%lf", x);
  if (g) { y = atof(g); printf(" + %lf*i", y); }
  printf("\n");

  // fudge factor 1
  a[0][m1] = 1;
  // c ^ 0
  p = pow((double)(10), pr);
  a[1][m1] = p;
  // compute powers
  for (r = 2; r <= m - 1; r++) {
    t = p;
    p = p * x - q * y;
    q = t * y + q * x;
    a[r][m1] = round(p);
    a[r][m2] = round(q);
  }
}

// input A and b
int64_t Inpsys()
{
  int64_t r = 0, s = 0, sw = 0;
  char *g = alloca(1024);

  for (r = 0; r <= n - 1; r++) {
    printf(" row A%ld and b%ld ", r + 1, r + 1);
    fgets(g, 1024, stdin);

    // reject all fractional coefficients
    sw = strpbrk(g, "\\./") != NULL ? 1 : 0;

    // parse row
    char *token = NULL, *str = NULL;
    s = 0;
    for ( str = g; ; str = NULL) {
      token = strtok(str, " |");
      if (token == NULL)
        break;
      a[s][m1 + r] = atoi(token);
      s ++;
    }
  }

  if (sw) { printf("illegal input\n"); };
  return sw;
}

// print row r
#define prow                                                \
    for (s = 0; s <= mn; s++) {                             \
      if (s == m1) { printf(" |"); }                        \
      for (int64_t spc = 0; spc < p[s] - l[r][s] + 1; spc++) {  \
        printf(" ");                                        \
      }                                                     \
      printf("% .0lf", a[r][s]);                            \
    }

// print matrix A(,)
void PrntM(int64_t sw)
{
  int64_t l[m+1][mn+1], p[mn+1], k = 0, r = 0, s = 0;
  char *g = alloca(1024); double q = 0;

  for (s = 0; s <= mn; s++) {
    p[s] = 1; for (r = 0; r <= m; r++) {
      // store lengths and max. length in column
      // for pretty output
      char *tmpg = alloca(1024);
      sprintf(tmpg, "%f", fabs(a[r][s]));
      l[r][s] = strlen(tmpg);
      if (l[r][s] > p[s]) { p[s] = l[r][s]; }
    }
  }

  if (sw) {
    printf("P | Hnf\n");

    // evaluate
    for (r = 0; r <= m; r++) {
      if (a[r][mn]) { k = r; break; }
    }
    sw = a[k][mn] == 1;
    for (s = m1; s <= mn - 1; s++) {
      sw &= a[k][s] == 0;
    }
    sw ? strcpy(g, "  -solution") : strcpy(g, "   inconsistent");
    for (s = 0; s <= m - 1; s++) {
      sw &= a[k][s] == 0;
    }
    if (sw) { g[0] = 0; } //  trivial

    // Hnf and solution
    for (r = m; r >= k; r--) {
      prow;
      printf("%s\n", r == k ? g : "");
    }
    // Null space with lengths squared
    for (r = 0; r <= k - 1; r++) {
      prow;
      q = 0; for (s = 0; s <= m - 1; s++) {
        q += a[r][s] * a[r][s];
      }
      printf("   (%.0f)\n", q);
    }

  } else {
    printf("I | Ab~\n");

    for (r = 0; r <= m; r++) {
      prow;
      printf("\n");
    }
  }
}

// ----------------------
// Part 2: HMM algorithm 4
// ------------------------

// negate rows t
void Minus(int64_t t)
{
  int64_t r, s;
  for (s = 0; s <= mn; s++) {
    a[t][s] = -a[t][s];
  }
  for (r = 1; r <= m; r++) {
    for (s = 0; s <= r - 1; s++) {
      if (r == t || s == t) {
        la[r][s] = -la[r][s];
      }
    }
  }
}

// LLL reduce rows k
void Reduce(int64_t k, int64_t t)
{
  int64_t s = 0, sx = 0;
  double lk = 0, q = 0;
  c1 = nx; c2 = nx;
  // pivot elements Ab~ in rows t and k
  for (s = m1; s <= mn; s++) {
    if (a[t][s]) { c1 = s; break; }
  }
  for (s = m1; s <= mn; s++) {
    if (a[k][s]) { c2 = s; break; }
  }

  q = 0;
  if (c1 < nx) {
    if (a[t][c1] < 0) { Minus(t); }
    q = floor(a[k][c1] / a[t][c1]); // floor
  } else {
    lk = la[k][t];
    if (2 * fabs(lk) > d[t]) {
      // 2|lambda_kt| > d_t
      // not LLL-reduced yet
      q = round(lk / d[t]); // round;
    }
  }

  if (q) {
    sx = c1 == nx ? m : mn;
    // reduce row k
    for (s = 0; s <= sx; s++) {
      a[k][s] -= q * a[t][s];
    }
    la[k][t] -= q * d[t];
    for (s = 0; s <= t - 1; s++) {
      la[k][s] -= q * la[t][s];
    }
  }
}

// exchange rows k and k-1
void Swop(int64_t k)
{
  int64_t r = 0, s = 0, t = k - 1;
  double db = 0, lk = 0, lr = 0;
  for (s = 0; s <= mn; s++) {
    swap(&a[k][s], &a[t][s]);
  }
  for (s = 0; s <= t - 1; s++) {
    swap(&la[k][s], &la[t][s]);
  }

  // update Gram coefficients
  // columns k, k-1 for r > k
  lk = la[k][t];
  db = (d[t - 1]*d[k] + lk*lk) / d[t];
  for (r = k + 1; r <= m; r++) {
    lr = la[r][k];
    la[r][k] = (d[k] * la[r][t] - lk * lr) / d[t];
    la[r][t] = (db * lr + lk * la[r][k]) / d[k];
  }
  d[t] = db;
}

// main limiting sequence
void Main(int64_t sw)
{
  int64_t i = 0, k = 0, t = 0, tl = 0;
  double db = 0, lk = 0;

  if (sw) {
    Inpconst(sw);
  } else {
    if (Inpsys()) { return; }
  }
  // augment Ab~ with column e_m
  a[m][mn] = 1;
  // prefix standard basis
  for (i = 0; i <= m; i++) { a[i][i] = 1; }
  // Gram sub-determinants
  for (i = -1; i <= m; i++) { d[i] = 1; }

  if (echo) { PrntM(0); }

  k = 1;
  while (k <= m)
  {
    t = k - 1;
    // partial size reduction
    Reduce(k, t);

    sw = (c1 == nx && c2 == nx);
    if (sw) {
      // zero rows k-1, k
      lk = la[k][t];
      // Lovasz condition
      // Bk >= (alpha - mu_kt^2) * Bt
      db = d[t - 1] * d[k] + lk * lk;
      // not satisfied
      sw = (db * ald) < (d[t] * d[t] * aln);
    }

    if (sw || (c1 <= c2 && c1 < nx)) {
      // test recommends a swap
      Swop(k);
      // decrease k
      if (k > 1) { k -= 1; }
    } else {
      // complete size reduction
      for (i = t - 1; i >= 0; i--) {
        Reduce(k, i);
      }
      // increase k
      k += 1;
    }

    tl += 1;
  }

  PrntM(-1);

  printf("loop %ld\n", tl);
}
