#include <fenv.h>	/* fegetround(), fesetround() */
#include <stdio.h>	/* printf() */

/*
 * Calculates an interval for a + b.
 *   interval[0] <= a + b
 *   a + b <= interval[1]
 */
void
safe_add(volatile double interval[2], volatile double a, volatile double b)
{
#pragma STDC FENV_ACCESS ON
	unsigned int orig;

	orig = fegetround();
	fesetround(FE_DOWNWARD);	/* round to -infinity */
	interval[0] = a + b;
	fesetround(FE_UPWARD);		/* round to +infinity */
	interval[1] = a + b;
	fesetround(orig);
}

int
main()
{
	const double nums[][2] = {
		{1, 2},
		{0.1, 0.2},
		{1e100, 1e-100},
		{1e308, 1e308},
	};
	double ival[2];
	int i;

	for (i = 0; i < sizeof(nums) / sizeof(nums[0]); i++) {
		/*
		 * Calculate nums[i][0] + nums[i][1].
		 */
		safe_add(ival, nums[i][0], nums[i][1]);

		/*
		 * Print the result. %.17g gives the best output.
		 * %.16g or plain %g gives not enough digits.
		 */
		printf("%.17g + %.17g =\n", nums[i][0], nums[i][1]);
		printf("    [%.17g, %.17g]\n", ival[0], ival[1]);
		printf("    size %.17g\n\n", ival[1] - ival[0]);
	}
	return 0;
}
