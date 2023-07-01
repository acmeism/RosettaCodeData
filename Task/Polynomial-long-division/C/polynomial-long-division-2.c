int main()
{
  int i;
  gsl_vector *q, *r;
  gsl_vector *nv, *dv;

  //nv = create_poly(4,  -42., 0., -12., 1.);
  //dv = create_poly(2,  -3., 1.);
  //nv = create_poly(3,  2., 3., 1.);
  //dv = create_poly(2,  1., 1.);
  nv = create_poly(4, -42., 0., -12., 1.);
  dv = create_poly(3, -3., 1., 1.);

  q = poly_long_div(nv, dv, &r);

  poly_print(q);
  poly_print(r);

  gsl_vector_free(q);
  gsl_vector_free(r);

  return 0;
}
