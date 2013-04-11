#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>
#include <gsl/gsl_vector.h>

#define MAX(A,B) (((A)>(B))?(A):(B))

void reoshift(gsl_vector *v, int h)
{
  if ( h > 0 ) {
    gsl_vector *temp = gsl_vector_alloc(v->size);
    gsl_vector_view p = gsl_vector_subvector(v, 0, v->size - h);
    gsl_vector_view p1 = gsl_vector_subvector(temp, h, v->size - h);
    gsl_vector_memcpy(&p1.vector, &p.vector);
    p = gsl_vector_subvector(temp, 0, h);
    gsl_vector_set_zero(&p.vector);
    gsl_vector_memcpy(v, temp);
    gsl_vector_free(temp);
  }
}

gsl_vector *poly_long_div(gsl_vector *n, gsl_vector *d, gsl_vector **r)
{
  gsl_vector *nt = NULL, *dt = NULL, *rt = NULL, *d2 = NULL, *q = NULL;
  int gn, gt, gd;

  if ( (n->size >= d->size) && (d->size > 0) && (n->size > 0) ) {
    nt = gsl_vector_alloc(n->size); assert(nt != NULL);
    dt = gsl_vector_alloc(n->size); assert(dt != NULL);
    rt = gsl_vector_alloc(n->size); assert(rt != NULL);
    d2 = gsl_vector_alloc(n->size); assert(d2 != NULL);
    gsl_vector_memcpy(nt, n);
    gsl_vector_set_zero(dt); gsl_vector_set_zero(rt);
    gsl_vector_view p = gsl_vector_subvector(dt, 0, d->size);
    gsl_vector_memcpy(&p.vector, d);
    gsl_vector_memcpy(d2, dt);
    gn = n->size - 1;
    gd = d->size - 1;
    gt = 0;

    while( gsl_vector_get(d, gd) == 0 ) gd--;

    while ( gn >= gd ) {
      reoshift(dt, gn-gd);
      double v = gsl_vector_get(nt, gn)/gsl_vector_get(dt, gn);
      gsl_vector_set(rt, gn-gd, v);
      gsl_vector_scale(dt, v);
      gsl_vector_sub(nt, dt);
      gt = MAX(gt, gn-gd);
      while( (gn>=0) && (gsl_vector_get(nt, gn) == 0.0) ) gn--;
      gsl_vector_memcpy(dt, d2);
    }

    q = gsl_vector_alloc(gt+1); assert(q != NULL);
    p = gsl_vector_subvector(rt, 0, gt+1);
    gsl_vector_memcpy(q, &p.vector);
    if ( r != NULL ) {
      if ( (gn+1) > 0 ) {
	*r = gsl_vector_alloc(gn+1); assert( *r != NULL );
	p = gsl_vector_subvector(nt, 0, gn+1);
	gsl_vector_memcpy(*r, &p.vector);
      } else {
	*r = gsl_vector_alloc(1); assert( *r != NULL );
	gsl_vector_set_zero(*r);
      }
    }
    gsl_vector_free(nt); gsl_vector_free(dt);
    gsl_vector_free(rt); gsl_vector_free(d2);
    return q;
  } else {
    q = gsl_vector_alloc(1); assert( q != NULL );
    gsl_vector_set_zero(q);
    if ( r != NULL ) {
      *r = gsl_vector_alloc(n->size); assert( *r != NULL );
      gsl_vector_memcpy(*r, n);
    }
    return q;
  }
}

void poly_print(gsl_vector *p)
{
  int i;
  for(i=p->size-1; i >= 0; i--) {
    if ( i > 0 )
      printf("%lfx^%d + ",
	     gsl_vector_get(p, i), i);
    else
      printf("%lf\n", gsl_vector_get(p, i));
  }
}

gsl_vector *create_poly(int d, ...)
{
  va_list al;
  int i;
  gsl_vector *r = NULL;

  va_start(al, d);
  r = gsl_vector_alloc(d); assert( r != NULL );

  for(i=0; i < d; i++)
    gsl_vector_set(r, i, va_arg(al, double));

  return r;
}
