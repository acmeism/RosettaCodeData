int main()
{
  complex double x[2];

  roots_quadratic_eq(1, -1e20, 1, x);
  printf("x1 = (%.20le, %.20le)\nx2 = (%.20le, %.20le)\n\n",
	 creal(x[0]), cimag(x[0]),
	 creal(x[1]), cimag(x[1]));
  roots_quadratic_eq2(1, -1e20, 1, x);
  printf("x1 = (%.20le, %.20le)\nx2 = (%.20le, %.20le)\n\n",
	 creal(x[0]), cimag(x[0]),
	 creal(x[1]), cimag(x[1]));

  return 0;
}
