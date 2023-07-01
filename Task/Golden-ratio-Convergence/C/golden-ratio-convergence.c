#include <stdio.h>
#include <math.h>

static void
using_float ()                  /* C2x does not require "void". */
{
  int count = 0;
  float phi0 = 1.0f;
  float phi1;
  float difference;
  do
    {
      phi1 = 1.0f + (1.0f / phi0);
      difference = fabsf (phi1 - phi0);
      phi0 = phi1;
      count += 1;
    }
  while (1.0e-5f < difference);

  printf ("Using type float --\n");
  printf ("Result: %f after %d iterations\n", phi1, count);
  printf ("The error is approximately %f\n",
          phi1 - (0.5f * (1.0f + sqrtf (5.0f))));
}

static void
using_double ()                 /* C2x does not require "void". */
{
  int count = 0;
  double phi0 = 1.0;
  double phi1;
  double difference;
  do
    {
      phi1 = 1.0 + (1.0 / phi0);
      difference = fabs (phi1 - phi0);
      phi0 = phi1;
      count += 1;
    }
  while (1.0e-5 < difference);

  printf ("Using type double --\n");
  printf ("Result: %f after %d iterations\n", phi1, count);
  printf ("The error is approximately %f\n",
          phi1 - (0.5 * (1.0 + sqrt (5.0))));
}

int
main ()                         /* C2x does not require "void". */
{
  using_float ();
  printf ("\n");
  using_double ();
}
