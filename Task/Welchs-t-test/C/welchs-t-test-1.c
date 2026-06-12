#include <stdio.h>
#include <math.h>
#include <stdlib.h>

double Pvalue (const double *restrict ARRAY1, const size_t ARRAY1_SIZE, const double *restrict ARRAY2, const size_t ARRAY2_SIZE) {//calculate a p-value based on an array
	if (ARRAY1_SIZE <= 1) {
		return 1.0;
	} else if (ARRAY2_SIZE <= 1) {
		return 1.0;
	}
	double fmean1 = 0.0, fmean2 = 0.0;
	for (size_t x = 0; x < ARRAY1_SIZE; x++) {//get sum of values in ARRAY1
		if (isfinite(ARRAY1[x]) == 0) {//check to make sure this is a real numbere
			puts("Got a non-finite number in 1st array, can't calculate P-value.");
			exit(EXIT_FAILURE);
		}
		fmean1 += ARRAY1[x];
	}
	fmean1 /= ARRAY1_SIZE;
	for (size_t x = 0; x < ARRAY2_SIZE; x++) {//get sum of values in ARRAY2
		if (isfinite(ARRAY2[x]) == 0) {//check to make sure this is a real number
			puts("Got a non-finite number in 2nd array, can't calculate P-value.");
			exit(EXIT_FAILURE);
		}
		fmean2 += ARRAY2[x];
	}
	fmean2 /= ARRAY2_SIZE;
//	printf("mean1 = %lf	mean2 = %lf\n", fmean1, fmean2);
	if (fmean1 == fmean2) {
		return 1.0;//if the means are equal, the p-value is 1, leave the function
	}
	double unbiased_sample_variance1 = 0.0, unbiased_sample_variance2 = 0.0;
	for (size_t x = 0; x < ARRAY1_SIZE; x++) {//1st part of added unbiased_sample_variance
		unbiased_sample_variance1 += (ARRAY1[x]-fmean1)*(ARRAY1[x]-fmean1);
	}
	for (size_t x = 0; x < ARRAY2_SIZE; x++) {
		unbiased_sample_variance2 += (ARRAY2[x]-fmean2)*(ARRAY2[x]-fmean2);
	}
//	printf("unbiased_sample_variance1 = %lf\tunbiased_sample_variance2 = %lf\n",unbiased_sample_variance1,unbiased_sample_variance2);//DEBUGGING
	unbiased_sample_variance1 = unbiased_sample_variance1/(ARRAY1_SIZE-1);
	unbiased_sample_variance2 = unbiased_sample_variance2/(ARRAY2_SIZE-1);
	const double WELCH_T_STATISTIC = (fmean1-fmean2)/sqrt(unbiased_sample_variance1/ARRAY1_SIZE+unbiased_sample_variance2/ARRAY2_SIZE);
	const double DEGREES_OF_FREEDOM = pow((unbiased_sample_variance1/ARRAY1_SIZE+unbiased_sample_variance2/ARRAY2_SIZE),2.0)//numerator
	 /
	(
		(unbiased_sample_variance1*unbiased_sample_variance1)/(ARRAY1_SIZE*ARRAY1_SIZE*(ARRAY1_SIZE-1))+
		(unbiased_sample_variance2*unbiased_sample_variance2)/(ARRAY2_SIZE*ARRAY2_SIZE*(ARRAY2_SIZE-1))
	);
//	printf("Welch = %lf	DOF = %lf\n", WELCH_T_STATISTIC, DEGREES_OF_FREEDOM);
		const double a = DEGREES_OF_FREEDOM/2;
	double value = DEGREES_OF_FREEDOM/(WELCH_T_STATISTIC*WELCH_T_STATISTIC+DEGREES_OF_FREEDOM);
	if ((isinf(value) != 0) || (isnan(value) != 0)) {
		return 1.0;
	}
	if ((isinf(value) != 0) || (isnan(value) != 0)) {
		return 1.0;
	}

/*  Purpose:

    BETAIN computes the incomplete Beta function ratio.

  Licensing:

    This code is distributed under the GNU LGPL license.

  Modified:

    05 November 2010

  Author:

    Original FORTRAN77 version by KL Majumder, GP Bhattacharjee.
    C version by John Burkardt.

  Reference:

    KL Majumder, GP Bhattacharjee,
    Algorithm AS 63:
    The incomplete Beta Integral,
    Applied Statistics,
    Volume 22, Number 3, 1973, pages 409-411.

  Parameters:
https://www.jstor.org/stable/2346797?seq=1#page_scan_tab_contents
    Input, double X, the argument, between 0 and 1.

    Input, double P, Q, the parameters, which
    must be positive.

    Input, double BETA, the logarithm of the complete
    beta function.

    Output, int *IFAULT, error flag.
    0, no error.
    nonzero, an error occurred.

    Output, double BETAIN, the value of the incomplete
    Beta function ratio.
*/
	const double beta = lgammal(a)+0.57236494292470009-lgammal(a+0.5);
	const double acu = 0.1E-14;
  double ai;
  double cx;
  int indx;
  int ns;
  double pp;
  double psq;
  double qq;
  double rx;
  double temp;
  double term;
  double xx;

//  ifault = 0;
//Check the input arguments.
  if ( (a <= 0.0)) {// || (0.5 <= 0.0 )){
//    *ifault = 1;
//    return value;
  }
  if ( value < 0.0 || 1.0 < value )
  {
//    *ifault = 2;
    return value;
  }
/*
  Special cases.
*/
  if ( value == 0.0 || value == 1.0 )   {
    return value;
  }
  psq = a + 0.5;
  cx = 1.0 - value;

  if ( a < psq * value )
  {
    xx = cx;
    cx = value;
    pp = 0.5;
    qq = a;
    indx = 1;
  }
  else
  {
    xx = value;
    pp = a;
    qq = 0.5;
    indx = 0;
  }

  term = 1.0;
  ai = 1.0;
  value = 1.0;
  ns = ( int ) ( qq + cx * psq );
/*
  Use the Soper reduction formula.
*/
  rx = xx / cx;
  temp = qq - ai;
  if ( ns == 0 )
  {
    rx = xx;
  }

  for ( ; ; )
  {
    term = term * temp * rx / ( pp + ai );
    value = value + term;;
    temp = fabs ( term );

    if ( temp <= acu && temp <= acu * value )
    {
      value = value * exp ( pp * log ( xx )
      + ( qq - 1.0 ) * log ( cx ) - beta ) / pp;

      if ( indx )
      {
        value = 1.0 - value;
      }
      break;
    }

    ai = ai + 1.0;
    ns = ns - 1;

    if ( 0 <= ns )
    {
      temp = qq - ai;
      if ( ns == 0 )
      {
        rx = xx;
      }
    }
    else
    {
      temp = psq;
      psq = psq + 1.0;
    }
  }
  return value;
}
//-------------------
int main(void) {

	const double d1[] = {27.5,21.0,19.0,23.6,17.0,17.9,16.9,20.1,21.9,22.6,23.1,19.6,19.0,21.7,21.4};
	const double d2[] = {27.1,22.0,20.8,23.4,23.4,23.5,25.8,22.0,24.8,20.2,21.9,22.1,22.9,20.5,24.4};
	const double d3[] = {17.2,20.9,22.6,18.1,21.7,21.4,23.5,24.2,14.7,21.8};
	const double d4[] = {21.5,22.8,21.0,23.0,21.6,23.6,22.5,20.7,23.4,21.8,20.7,21.7,21.5,22.5,23.6,21.5,22.5,23.5,21.5,21.8};
	const double d5[] = {19.8,20.4,19.6,17.8,18.5,18.9,18.3,18.9,19.5,22.0};
	const double d6[] = {28.2,26.6,20.1,23.3,25.2,22.1,17.7,27.6,20.6,13.7,23.2,17.5,20.6,18.0,23.9,21.6,24.3,20.4,24.0,13.2};
	const double d7[] = {30.02,29.99,30.11,29.97,30.01,29.99};
	const double d8[] = {29.89,29.93,29.72,29.98,30.02,29.98};
	const double x[] = {3.0,4.0,1.0,2.1};
	const double y[] = {490.2,340.0,433.9};
	const double v1[] = {0.010268,0.000167,0.000167};
	const double v2[] = {0.159258,0.136278,0.122389};
	const double s1[] = {1.0/15,10.0/62.0};
	const double s2[] = {1.0/10,2/50.0};
	const double z1[] = {9/23.0,21/45.0,0/38.0};
	const double z2[] = {0/44.0,42/94.0,0/22.0};
	
	const double CORRECT_ANSWERS[] = {0.021378001462867,
0.148841696605327,
0.0359722710297968,
0.090773324285671,
0.0107515611497845,
0.00339907162713746,
0.52726574965384,
0.545266866977794};

//calculate the pvalues and show that they're the same as the R values

	double pvalue = Pvalue(d1,sizeof(d1)/sizeof(*d1),d2,sizeof(d2)/sizeof(*d2));
	double error = fabs(pvalue - CORRECT_ANSWERS[0]);
	printf("Test sets 1 p-value = %g\n", pvalue);
	
	pvalue = Pvalue(d3,sizeof(d3)/sizeof(*d3),d4,sizeof(d4)/sizeof(*d4));
	error += fabs(pvalue - CORRECT_ANSWERS[1]);
	printf("Test sets 2 p-value = %g\n",pvalue);

	pvalue = Pvalue(d5,sizeof(d5)/sizeof(*d5),d6,sizeof(d6)/sizeof(*d6));
	error += fabs(pvalue - CORRECT_ANSWERS[2]);
	printf("Test sets 3 p-value = %g\n", pvalue);

	pvalue = Pvalue(d7,sizeof(d7)/sizeof(*d7),d8,sizeof(d8)/sizeof(*d8));
	printf("Test sets 4 p-value = %g\n", pvalue);
	error += fabs(pvalue - CORRECT_ANSWERS[3]);

	pvalue = Pvalue(x,sizeof(x)/sizeof(*x),y,sizeof(y)/sizeof(*y));
	error += fabs(pvalue - CORRECT_ANSWERS[4]);
	printf("Test sets 5 p-value = %g\n", pvalue);

	pvalue = Pvalue(v1,sizeof(v1)/sizeof(*v1),v2,sizeof(v2)/sizeof(*v2));
	error += fabs(pvalue - CORRECT_ANSWERS[5]);
	printf("Test sets 6 p-value = %g\n", pvalue);
	
	pvalue = Pvalue(s1,sizeof(s1)/sizeof(*s1),s2,sizeof(s2)/sizeof(*s2));
	error += fabs(pvalue - CORRECT_ANSWERS[6]);
	printf("Test sets 7 p-value = %g\n", pvalue);
	
	pvalue = Pvalue(z1, 3, z2, 3);
	error += fabs(pvalue - CORRECT_ANSWERS[7]);
	printf("Test sets z p-value = %g\n", pvalue);

	printf("the cumulative error is %g\n", error);
	return 0;
}
