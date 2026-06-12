/*------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <limits.h>
#include <float.h>
#include <math.h>
#include <gc/gc.h>              /* Boehm GC. */
#include <gmp.h>                /* GNU Multiple Precision. */

void *
my_malloc (size_t size)
{
  void *p = GC_MALLOC (size);
  if (p == NULL)
    {
      fprintf (stderr, "Memory allocation failed.\n");
      exit (1);
    }
  return p;
}

void *
my_realloc (void *p, size_t size)
{
  void *q = GC_REALLOC (p, size);
  if (q == NULL)
    {
      fprintf (stderr, "Memory allocation failed.\n");
      exit (1);
    }
  return q;
}

void
my_free (void *p)
{
  GC_FREE (p);
}

/*------------------------------------------------------------------*/
/* Some helper functions. */

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAX(x, y) (((x) > (y)) ? (x) : (y))

char *
string_append1 (const char *s1)
{
  size_t n1 = strlen (s1);
  char *s = my_malloc ((n1 + 1) * sizeof (char));
  s[n1] = '\0';
  memcpy (s, s1, n1);
  return s;
}

char *
string_append2 (const char *s1, const char *s2)
{
  size_t n1 = strlen (s1);
  size_t n2 = strlen (s2);
  char *s = my_malloc ((n1 + n2 + 1) * sizeof (char));
  s[n1 + n2] = '\0';
  memcpy (s, s1, n1);
  memcpy (s + n1, s2, n2);
  return s;
}

char *
string_append3 (const char *s1, const char *s2, const char *s3)
{
  size_t n1 = strlen (s1);
  size_t n2 = strlen (s2);
  size_t n3 = strlen (s3);
  char *s = my_malloc ((n1 + n2 + n3 + 1) * sizeof (char));
  s[n1 + n2 + n3] = '\0';
  memcpy (s, s1, n1);
  memcpy (s + n1, s2, n2);
  memcpy (s + n1 + n2, s3, n3);
  return s;
}

char *
string_repeat (size_t n, const char *s)
{
  /* This brute force implementation will suffice. */
  char *t = "";
  for (size_t i = 0; i != n; i += 1)
    t = string_append2 (t, s);
  return t;
}

/*------------------------------------------------------------------*/

typedef mpz_t *cf_func (size_t i, void *env);

struct cf
{
  bool terminated;              /* Are there no more terms? */
  size_t m;                     /* The number of terms memoized. */
  size_t n;                     /* The size of memoization storage. */
  mpz_t **memo;                 /* Memoization storage. */
  cf_func *func;                /* A function that produces terms. */
  void *env;                    /* An environment for func. */
};

typedef struct cf *cf_t;

cf_t
make_cf (cf_func *func, void *env)
{
  cf_t cf = my_malloc (sizeof (struct cf));
  cf->terminated = false;
  cf->m = 0;
  cf->n = 32;
  cf->memo = my_malloc (cf->n * sizeof (mpz_t *));
  cf->func = func;
  cf->env = env;
  return cf;
}

void
resize_cf (cf_t cf, size_t minimum)
{
  /* Ensure there is at least twice the minimum storage. */
  size_t size = 2 * minimum;
  if (cf->n < size)
    {
      cf->memo = my_realloc (cf->memo, size * sizeof (mpz_t *));
      cf->n = size;
    }
}

void
update_cf (cf_t cf, size_t needed)
{
  /* Ensure there are at least a certain number of finite terms
     memoized (or else that all of them are memoized). */
  if (!cf->terminated && cf->m < needed)
    {
      if (cf->n < needed)
        resize_cf (cf, needed);
      while (!cf->terminated && cf->m != needed)
        {
          cf->memo[cf->m] = cf->func (cf->m, cf->env);
          cf->m += 1;
        }
    }
}

mpz_t *
cf_ref (cf_t cf, size_t i)
{
  /* Get the ith term, or a NULL pointer if there is no finite ith
     term. */
  update_cf (cf, i + 1);
  return (i < cf->m) ? cf->memo[i] : NULL;
}

size_t default_max_terms = 20;

char *
cf2string (cf_t cf, size_t max_terms)
{
  if (max_terms == 0)
    max_terms = default_max_terms;

  size_t i = 0;
  char *s = string_append1 ("[");
  bool done = false;
  while (!done)
    {
      mpz_t *term = cf_ref (cf, i);
      if (term == NULL)
        {
          s = string_append2 (s, "]");
          done = true;
        }
      else if (i == max_terms)
        {
          s = string_append2 (s, ",...]");
          done = true;
        }
      else
        {
          static const char *separators[3] = { "", ";", "," };
          const char *separator = separators[(i <= 1) ? i : 2];
          const char *term_str = mpz_get_str (NULL, 10, *term);
          s = string_append3 (s, separator, term_str);
          i += 1;
        }
    }
  return s;
}

/*------------------------------------------------------------------*/

cf_t golden_ratio;
cf_t silver_ratio;

mpz_t *
return_constant ([[maybe_unused]] size_t i, void *env)
{
  mpz_t *term = my_malloc (sizeof (mpz_t));
  mpz_init_set (*term, *((mpz_t *) env));
  return term;
}

cf_t
make_cf_with_constant_terms (int term_si)
{
  mpz_t *env = my_malloc (sizeof (mpz_t));
  mpz_init_set_si (*env, term_si);
  return make_cf (return_constant, env);
}

/*------------------------------------------------------------------*/

cf_t sqrt2;

mpz_t *
return_sqrt2_term (size_t i, [[maybe_unused]] void *env)
{
  mpz_t *term = my_malloc (sizeof (mpz_t));
  mpz_init_set_si (*term, (i == 0) ? 1 : 2);
  return term;
}

cf_t
make_cf_sqrt2 (void)
{
  return make_cf (return_sqrt2_term, NULL);
}

/*------------------------------------------------------------------*/

cf_t frac_13_11;
cf_t frac_22_7;
cf_t one;
cf_t two;
cf_t three;
cf_t four;

mpz_t *
return_rational_term ([[maybe_unused]] size_t i, void *env)
{
  mpz_t *frac = env;
  mpz_t *term = NULL;
  if (mpz_sgn (frac[1]) != 0)
    {
      term = my_malloc (sizeof (mpz_t));
      mpz_init (*term);
      mpz_t r;
      mpz_init (r);
      mpz_fdiv_qr (*term, r, frac[0], frac[1]);
      mpz_set (frac[0], frac[1]);
      mpz_set (frac[1], r);
    }
  return term;
}

cf_t
make_cf_rational (int numerator_si, int denominator_si)
{
  mpz_t *env = my_malloc (2 * sizeof (mpz_t));
  mpz_init_set_si (env[0], numerator_si);
  mpz_init_set_si (env[1], denominator_si);
  return make_cf (return_rational_term, env);
}

cf_t
make_cf_integer (int integer_si)
{
  return make_cf_rational (integer_si, 1);
}

/*------------------------------------------------------------------*/

/* Thresholds. */
mpz_t number_that_is_too_big;
mpz_t practically_infinite;

struct ng8_env
{
  mpz_t ng[8];
  cf_t x;
  cf_t y;
  size_t ix;
  size_t iy;
  bool xoverflow;
  bool yoverflow;
};

typedef struct ng8_env *ng8_env_t;

enum ng8_index
{
  ng8a12 = 0,
  ng8a1  = 1,
  ng8a2  = 2,
  ng8a   = 3,
  ng8b12 = 4,
  ng8b1  = 5,
  ng8b2  = 6,
  ng8b   = 7
};

static bool
ng8_too_big (const mpz_t ng[8])
{
  bool too_big = false;
  int i = 0;
  while (!too_big && i != 8)
    {
      too_big = (0 <= mpz_cmpabs (ng[i], number_that_is_too_big));
      i += 1;
    }
  return too_big;
}

static bool
treat_ng8_term_as_infinite (const mpz_t term)
{
  return (0 <= mpz_cmpabs (term, practically_infinite));
}

static void
a_plus_bc (mpz_t result, const mpz_t a,  const mpz_t b,
           const mpz_t c)
{
  mpz_set (result, a);
  mpz_addmul (result, b, c);
}

static void
abc (mpz_t result, const mpz_t a,  const mpz_t b, const mpz_t c)
{
  mpz_mul (result, a, b);
  mpz_mul (result, result, c);
}

static void
absorb_x_term (ng8_env_t env)
{
  mpz_t tmp[8];
  for (int i = 0; i != 8; i += 1)
    mpz_init_set (tmp[i], env->ng[i]);
  mpz_t *term = (!env->xoverflow) ? cf_ref (env->x, env->ix) : NULL;
  env->ix += 1;
  mpz_set (env->ng[ng8a2], tmp[ng8a12]);
  mpz_set (env->ng[ng8a], tmp[ng8a1]);
  mpz_set (env->ng[ng8b2], tmp[ng8b12]);
  mpz_set (env->ng[ng8b], tmp[ng8b1]);
  if (term != NULL)
    {
      a_plus_bc (env->ng[ng8a12], tmp[ng8a2], tmp[ng8a12], *term);
      a_plus_bc (env->ng[ng8a1], tmp[ng8a], tmp[ng8a1], *term);
      a_plus_bc (env->ng[ng8b12], tmp[ng8b2], tmp[ng8b12], *term);
      a_plus_bc (env->ng[ng8b1], tmp[ng8b], tmp[ng8b1], *term);
      if (ng8_too_big (env->ng))
        {
          env->xoverflow = true;
          mpz_set (env->ng[ng8a12], tmp[ng8a12]);
          mpz_set (env->ng[ng8a1], tmp[ng8a1]);
          mpz_set (env->ng[ng8b12], tmp[ng8b12]);
          mpz_set (env->ng[ng8b1], tmp[ng8b1]);
        }
    }
}

static void
absorb_y_term (ng8_env_t env)
{
  mpz_t tmp[8];
  for (int i = 0; i != 8; i += 1)
    mpz_init_set (tmp[i], env->ng[i]);
  mpz_t *term = (!env->yoverflow) ? cf_ref (env->y, env->iy) : NULL;
  env->iy += 1;
  mpz_set (env->ng[ng8a1], tmp[ng8a12]);
  mpz_set (env->ng[ng8a], tmp[ng8a2]);
  mpz_set (env->ng[ng8b1], tmp[ng8b12]);
  mpz_set (env->ng[ng8b], tmp[ng8b2]);
  if (term != NULL)
    {
      a_plus_bc (env->ng[ng8a12], tmp[ng8a1], tmp[ng8a12], *term);
      a_plus_bc (env->ng[ng8a2], tmp[ng8a], tmp[ng8a2], *term);
      a_plus_bc (env->ng[ng8b12], tmp[ng8b1], tmp[ng8b12], *term);
      a_plus_bc (env->ng[ng8b2], tmp[ng8b], tmp[ng8b2], *term);
      if (ng8_too_big (env->ng))
        {
          env->yoverflow = true;
          mpz_set (env->ng[ng8a12], tmp[ng8a12]);
          mpz_set (env->ng[ng8a2], tmp[ng8a2]);
          mpz_set (env->ng[ng8b12], tmp[ng8b12]);
          mpz_set (env->ng[ng8b2], tmp[ng8b2]);
        }
    }
}

mpz_t *
return_ng8_term ([[maybe_unused]] size_t i, void *env)
{
  /* The McCabe complexity of this function is high. Please be careful
     if modifying the code. */

  ng8_env_t p = env;

  mpz_t *term = NULL;

  bool done = false;
  while (!done)
    {
      const bool b12_zero = (mpz_sgn (p->ng[ng8b12]) == 0);
      const bool b1_zero = (mpz_sgn (p->ng[ng8b1]) == 0);
      const bool b2_zero = (mpz_sgn (p->ng[ng8b2]) == 0);
      const bool b_zero = (mpz_sgn (p->ng[ng8b]) == 0);

      if (b_zero && b1_zero && b2_zero && b12_zero)
        done = true;            /* There are no more terms. */
      else if (b_zero && b2_zero)
        absorb_x_term (p);
      else if (b_zero || b2_zero)
        absorb_y_term (p);
      else if (b1_zero)
        absorb_x_term (p);
      else
        {
          mpz_t q, r;
          mpz_inits (q, r, NULL);
          mpz_t q1, r1;
          mpz_inits (q1, r1, NULL);
          mpz_t q2, r2;
          mpz_inits (q2, r2, NULL);
          mpz_t q12, r12;
          mpz_inits (q12, r12, NULL);

          mpz_fdiv_qr (q, r, p->ng[ng8a], p->ng[ng8b]);
          mpz_fdiv_qr (q1, r1, p->ng[ng8a1], p->ng[ng8b1]);
          mpz_fdiv_qr (q2, r2, p->ng[ng8a2], p->ng[ng8b2]);
          if (!b12_zero)
            mpz_fdiv_qr (q12, r12, p->ng[ng8a12], p->ng[ng8b12]);

          if (!b12_zero
              && mpz_cmp (q, q1) == 0
              && mpz_cmp (q, q2) == 0
              && mpz_cmp (q, q12) == 0)
            {
              // Output a term.
              mpz_set (p->ng[ng8a12], p->ng[ng8b12]);
              mpz_set (p->ng[ng8a1],  p->ng[ng8b1]);
              mpz_set (p->ng[ng8a2],  p->ng[ng8b2]);
              mpz_set (p->ng[ng8a],   p->ng[ng8b]);
              mpz_set (p->ng[ng8b12], r12);
              mpz_set (p->ng[ng8b1],  r1);
              mpz_set (p->ng[ng8b2],  r2);
              mpz_set (p->ng[ng8b],   r);
              if (!treat_ng8_term_as_infinite (q))
                {
                  term = my_malloc (sizeof (mpz_t));
                  mpz_init_set (*term, q);
                }
              done = true;
            }
          else
            {
              /* Rather than compare fractions, we will put the
                 numerators over a common denominator of b*b1*b2, and
                 then compare the new numerators. */
              mpz_t n, n1, n2, n1_diff, n2_diff;
              mpz_inits (n, n1, n2, n1_diff, n2_diff, NULL);
              abc (n, p->ng[ng8a], p->ng[ng8b1], p->ng[ng8b2]);
              abc (n1, p->ng[ng8a1], p->ng[ng8b], p->ng[ng8b2]);
              abc (n2, p->ng[ng8a2], p->ng[ng8b], p->ng[ng8b1]);
              mpz_sub (n1_diff, n1, n);
              mpz_sub (n2_diff, n2, n);
              if (mpz_cmpabs (n1_diff, n2_diff) > 0)
                absorb_x_term (p);
              else
                absorb_y_term (p);
            }
        }
    }

  return term;
}

cf_t
make_cf_ng8 (int ng[8], cf_t x, cf_t y)
{
  ng8_env_t env = my_malloc (sizeof (struct ng8_env));
  for (int i = 0; i != 8; i += 1)
    mpz_init_set_si (env->ng[i], ng[i]);
  env->x = x;
  env->y = y;
  env->ix = 0;
  env->iy = 0;
  env->xoverflow = false;
  env->yoverflow = false;
  return make_cf (return_ng8_term, env);
}

/*------------------------------------------------------------------*/

static void *
gmp_malloc (size_t alloc_size)
{
  return my_malloc (alloc_size);
}

static void *
gmp_realloc (void *p,
             [[maybe_unused]] size_t old_size,
             size_t new_size)
{
  return my_realloc (p, new_size);
}

static void
gmp_free (void *p, [[maybe_unused]] size_t size)
{
  /* There is no need for us to explicitly free memory, and
     performance might even suffer if we do. On the other hand, maybe
     GMP will free memory that otherwise would have been passed over
     for collection. */
  my_free (p);                  /* <-- optional */
}

void
show (const char *expression, cf_t cf, const char *note)
{
  size_t nexpr = strlen (expression);
  char *padding = string_repeat (MAX (19, nexpr + 1) - nexpr, " ");
  char *line = string_append3 (padding, expression, " =>  ");
  char *cfstr = cf2string (cf, 0);
  line = string_append2 (line, cfstr);
  if (note != NULL)
    {
      size_t ncfstr = strlen (cfstr);
      padding = string_repeat (MAX (48, ncfstr + 1) - ncfstr, " ");
      line = string_append3 (line, padding, note);
    }
  puts (line);
}

int ng8_add[8] = { 0, 1, 1, 0, 0, 0, 0, 1 };
int ng8_sub[8] = { 0, 1, -1, 0, 0, 0, 0, 1 };
int ng8_mul[8] = { 1, 0, 0, 0, 0, 0, 0, 1 };
int ng8_div[8] = { 0, 1, 0, 0, 0, 0, 1, 0 };

int
main (void)
{
  GC_INIT ();

  /* GMP has to be told to use Boehm GC as its allocator. */
  mp_set_memory_functions (gmp_malloc, gmp_realloc, gmp_free);

  /* Initialize thresholds, to values chosen merely for
     demonstration. */
  mpz_init_set_si (number_that_is_too_big, 1);
  mpz_mul_2exp (number_that_is_too_big, number_that_is_too_big,
                512);           /* 2**512 */
  mpz_init_set_si (practically_infinite, 1);
  mpz_mul_2exp (practically_infinite, practically_infinite,
                64);            /* 2**64 */

  /* Initialize global continued fractions. */
  golden_ratio = make_cf_with_constant_terms (1);
  silver_ratio = make_cf_with_constant_terms (2);
  sqrt2 = make_cf_sqrt2 ();
  frac_13_11 = make_cf_rational (13, 11);
  frac_22_7 = make_cf_rational (22, 7);
  one = make_cf_integer (1);
  two = make_cf_integer (2);
  three = make_cf_integer (3);
  four = make_cf_integer (4);

  /* Divide the silver ratio by 2 times the square root of 2. */
  int ng8_method1[8] = { 0, 1, 0, 0, 0, 0, 2, 0 };
  cf_t method1 = make_cf_ng8 (ng8_method1, silver_ratio, sqrt2);

  /* Add 1/8 to 1/8th of the square of the silver ratio. */
  int ng8_method2[8] = { 1, 0, 0, 1, 0, 0, 0, 8 };
  cf_t method2 = make_cf_ng8 (ng8_method2, silver_ratio,
                              silver_ratio);

  /* Thrice divide the silver ratio by the square root of 2. */
  cf_t method3 = make_cf_ng8 (ng8_div, silver_ratio, sqrt2);
  method3 = make_cf_ng8 (ng8_div, method3, sqrt2);
  method3 = make_cf_ng8 (ng8_div, method3, sqrt2);

  show ("golden ratio", golden_ratio, "(1 + sqrt(5))/2");
  show ("silver ratio", silver_ratio, "1 + sqrt(2)");
  show ("sqrt(2)", sqrt2, NULL);
  show ("13/11", frac_13_11, NULL);
  show ("22/7", frac_22_7, NULL);
  show ("one", one, NULL);
  show ("two", two, NULL);
  show ("three", three, NULL);
  show ("four", four, NULL);
  show ("(1 + 1/sqrt(2))/2", method1, "method 1");
  show ("(1 + 1/sqrt(2))/2", method2, "method 2");
  show ("(1 + 1/sqrt(2))/2", method3, "method 3");
  show ("sqrt(2) + sqrt(2)", make_cf_ng8 (ng8_add, sqrt2, sqrt2),
        NULL);
  show ("sqrt(2) - sqrt(2)", make_cf_ng8 (ng8_sub, sqrt2, sqrt2),
        NULL);
  show ("sqrt(2) * sqrt(2)", make_cf_ng8 (ng8_mul, sqrt2, sqrt2),
        NULL);
  show ("sqrt(2) / sqrt(2)", make_cf_ng8 (ng8_div, sqrt2, sqrt2),
        NULL);

  return 0;
}

/*------------------------------------------------------------------*/
