/*------------------------------------------------------------------*/
/* For C with Boehm GC as garbage collector. */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <gc.h>                 /* Boehm GC. */

/*------------------------------------------------------------------*/

/* Let us choose an integer type. */
typedef long long int integer;

/* We need consistent definitions of division and remainder. Let us
   set those here. For convenience (because C provides it), we will
   use truncation towards zero. */
#define DIV(a, b) ((a) / (b))
#define REM(a, b) ((a) % (b))

/* Choose a memory allocator: Boehm GC. (Ideally one should check for
   NULL return values, but for this pedagogical example let us skip
   that.) */
#define MALLOC_INIT() GC_INIT ()
#define MALLOC GC_MALLOC
#define REALLOC GC_REALLOC
#define FREE GC_FREE            /* Or one could make this a no-op. */

/*------------------------------------------------------------------*/
/* Some operations on char-strings. (In practice, I would write an m4
   macro to create such repetitive C functions for me. Of course, it
   is also possible to use <stdarg.h> or some such [generally unsafe]
   mechanism.) */

static char *
string_append1 (const char *s1)
{
  size_t n1 = strlen (s1);
  char *s = MALLOC (n1 + 1);
  s[n1] = '\0';
  memcpy (s, s1, n1);
  return s;
}

static char *
string_append2 (const char *s1, const char *s2)
{
  size_t n1 = strlen (s1);
  size_t n2 = strlen (s2);
  char *s = MALLOC (n1 + n2 + 1);
  s[n1 + n2] = '\0';
  memcpy (s, s1, n1);
  memcpy (s + n1, s2, n2);
  return s;
}

static char *
string_append3 (const char *s1, const char *s2, const char *s3)
{
  size_t n1 = strlen (s1);
  size_t n2 = strlen (s2);
  size_t n3 = strlen (s3);
  char *s = MALLOC (n1 + n2 + n3 + 1);
  s[n1 + n2 + n3] = '\0';
  memcpy (s, s1, n1);
  memcpy (s + n1, s2, n2);
  memcpy (s + n1 + n2, s3, n3);
  return s;
}

/*------------------------------------------------------------------*/
/* Continued fractions as processes for generating terms. The terms
   are memoized and are accessed by their zero-based index. */

typedef void cf_generator_func_t (void *env, bool *there_is_a_term,
                                  integer *term);

struct _cf_generator  /* For practical purposes, this is a closure. */
{
  cf_generator_func_t *func;
  void *env;
};

typedef struct _cf_generator *cf_generator_t;

struct _cf
{
  bool terminated;          /* No more terms? */
  size_t m;                 /* The number of terms computed so far. */
  size_t n;                 /* The size of memo storage. */
  integer *memo;            /* Memoized terms. */
  cf_generator_t gen;       /* A closure to generate terms. */
};

typedef struct _cf *cf_t;

cf_generator_t
cf_generator_make (cf_generator_func_t func, void *env)
{
  cf_generator_t gen = MALLOC (sizeof (struct _cf_generator));
  gen->func = func;
  gen->env = env;
  return gen;
}

cf_t
cf_make (cf_generator_t gen)
{
  const size_t start_size = 8;
  integer *memo = MALLOC (start_size * sizeof (integer));
  cf_t cf = MALLOC (sizeof (struct _cf));
  cf->terminated = false;
  cf->m = 0;
  cf->n = start_size;
  cf->memo = memo;
  cf->gen = gen;
  return cf;
}

static void
_cf_get_more_terms (cf_t cf, size_t needed)
{
  size_t term_count = cf->m;
  bool done = false;
  while (!done)
    {
      if (term_count == needed)
        {
          cf->m = needed;
          done = true;
        }
      else
        {
          bool there_is_a_term;
          integer term;
          cf->gen->func (cf->gen->env, &there_is_a_term, &term);
          if (there_is_a_term)
            {
              cf->memo[term_count] = term;
              term_count += 1;
            }
          else
            {
              cf->terminated = true;
              cf->m = term_count;
              done = true;
            }
        }
    }
}

static void
_cf_update (cf_t cf, size_t needed)
{
  if (cf->terminated || needed <= (cf->m))
    /* Do nothing. */ ;
  else if (needed <= (cf->n))
    _cf_get_more_terms (cf, needed);
  else
    {
      /* Provide twice the needed storage. */
      cf->n = 2 * needed;
      cf->memo = REALLOC (cf->memo, cf->n * sizeof (integer));
      _cf_get_more_terms (cf, needed);
    }
}

void
cf_get_at (cf_t cf, size_t i, bool *there_is_a_term,
           integer *term)
{
  _cf_update (cf, i + 1);
  *there_is_a_term = (i < (cf->m));
  if (*there_is_a_term)
    *term = cf->memo[i];
}

char *
cf2string_max_terms (cf_t cf, size_t max_terms)
{
  char *s = string_append1 ("[");
  const char *sep = "";
  size_t i = 0;
  bool done = false;
  while (!done)
    {
      if (i == max_terms)
        {
          s = string_append2 (s, ",...]");
          done = true;
        }
      else
        {
          bool there_is_a_term;
          integer term;
          cf_get_at (cf, i, &there_is_a_term, &term);
          if (there_is_a_term)
            {
              char buf1[1];
              const int numeral_len =
                snprintf (buf1, 1, "%jd", (intmax_t) term);
              char buf[numeral_len + 1];
              snprintf (buf, numeral_len + 1, "%jd", (intmax_t) term);
              s = string_append3 (s, sep, buf);
              sep = (sep[0] == '\0') ? ";" : ",";
              i += 1;
            }
          else
            {
              s = string_append2 (s, "]");
              done = true;
            }
        }
    }
  return s;
}

char *
cf2string (cf_t cf)
{
  const size_t default_max_terms = 20;
  return cf2string_max_terms (cf, default_max_terms);
}

/*------------------------------------------------------------------*/
/* Using a cf_t as a cf_generator_t. */

struct _cf_gen_env
{
  cf_t cf;
  size_t i;
};

static void
cf_gen_run (void *env, bool *there_is_a_term, integer *term)
{
  struct _cf_gen_env *state = env;
  cf_get_at (state->cf, state->i, there_is_a_term, term);
  state->i += 1;
}

cf_generator_t
cf_gen_make (cf_t cf)
{
  struct _cf_gen_env *state = MALLOC (sizeof (struct _cf_gen_env));
  state->cf = cf;
  state->i = 0;
  return cf_generator_make (cf_gen_run, state);
}

/*------------------------------------------------------------------*/
/* A homographic function. */

struct _hfunc
{
  integer a1;
  integer a;
  integer b1;
  integer b;
};

typedef struct _hfunc *hfunc_t;

struct _hfunc_gen_env
{
  struct _hfunc state;
  cf_generator_t gen;
};

hfunc_t
hfunc_make (integer a1, integer a, integer b1, integer b)
{
  hfunc_t f = MALLOC (sizeof (struct _hfunc));
  f->a1 = a1;
  f->a = a;
  f->b1 = b1;
  f->b = b;
  return f;
}

static void
_take_term_from_ngen (struct _hfunc *state,
                      cf_generator_t ngen)
{
  const integer a1 = state->a1;
  const integer b1 = state->b1;

  bool there_is_a_term;
  integer term;
  ngen->func (ngen->env, &there_is_a_term, &term);
  if (there_is_a_term)
    {
      const integer a = state->a;
      const integer b = state->b;

      state->a1 = a + (a1 * term);
      state->a = a1;
      state->b1 = b + (b1 * term);
      state->b = b1;
    }
  else
    {
      state->a = a1;
      state->b = b1;
    }
}

static void
_adjust_state_for_term_output (struct _hfunc *state,
                               integer term)
{
  const integer a1 = state->a1;
  const integer a = state->a;
  const integer b1 = state->b1;
  const integer b = state->b;

  state->a1 = b1;
  state->a = b;
  state->b1 = a1 - (b1 * term);
  state->b = a - (b * term);
}

static void
hfunc_gen_run (void *env, bool *there_is_a_term, integer *term)
{
  struct _hfunc *state = &(((struct _hfunc_gen_env *) env)->state);
  cf_generator_t ngen = ((struct _hfunc_gen_env *) env)->gen;

  bool done = false;
  while (!done)
    {
      const bool b1_iseqz = (state->b1 == 0);
      const bool b_iseqz = (state->b == 0);
      if (b1_iseqz && b_iseqz)
        {
          *there_is_a_term = false;
          done = true;
        }
      else if (!b1_iseqz && !b_iseqz)
        {
          const integer q1 = DIV (state->a1, state->b1);
          const integer q = DIV (state->a, state->b);
          if (q1 == q)
            {
              _adjust_state_for_term_output (state, q);
              *there_is_a_term = true;
              *term = q;
              done = true;
            }
          else
            _take_term_from_ngen (state, ngen);
        }
      else
        _take_term_from_ngen (state, ngen);
    }
}

/* Make a new generator that applies an hfunc_t to another
   generator. */
cf_generator_t
hfunc_gen_make (hfunc_t f, cf_generator_t gen)
{
  struct _hfunc_gen_env *env =
    MALLOC (sizeof (struct _hfunc_gen_env));
  env->state = *f;
  env->gen = gen;
  return cf_generator_make (hfunc_gen_run, env);
}

/* Make a new cf_t that applies an hfunc_t to another cf_t. */
cf_t
hfunc_apply (hfunc_t f, cf_t cf)
{
  cf_generator_t gen1 = cf_gen_make (cf);
  cf_generator_t gen2 = hfunc_gen_make (f, gen1);
  return cf_make (gen2);
}

/*------------------------------------------------------------------*/
/* Creation of a cf_t for a rational number. */

struct _r2cf_gen_env
{
  integer n;
  integer d;
};

static void
r2cf_gen_run (void *env, bool *there_is_a_term, integer *term)
{
  struct _r2cf_gen_env *state = env;
  *there_is_a_term = (state->d != 0);
  if (*there_is_a_term)
    {
      const integer q = DIV (state->n, state->d);
      const integer r = REM (state->n, state->d);
      state->n = state->d;
      state->d = r;
      *term = q;
    }
}

cf_generator_t
r2cf_gen_make (integer n, integer d)
{
  struct _r2cf_gen_env *state =
    MALLOC (sizeof (struct _r2cf_gen_env));
  state->n = n;
  state->d = d;
  return cf_generator_make (r2cf_gen_run, state);
}

cf_t
r2cf (integer n, integer d)
{
  return cf_make (r2cf_gen_make (n, d));
}

/*------------------------------------------------------------------*/
/* Creation of a cf_t for sqrt(2). */

struct _sqrt2_gen_env
{
  integer term;
};

static void
sqrt2_gen_run (void *env, bool *there_is_a_term, integer *term)
{
  struct _sqrt2_gen_env *state = env;
  *there_is_a_term = true;
  *term = state->term;
  state->term = 2;
}

cf_generator_t
sqrt2_gen_make (void)
{
  struct _sqrt2_gen_env *state =
    MALLOC (sizeof (struct _sqrt2_gen_env));
  state->term = 1;
  return cf_generator_make (sqrt2_gen_run, state);
}

cf_t
sqrt2_make (void)
{
  return cf_make (sqrt2_gen_make ());
}

/*------------------------------------------------------------------*/

int
main (void)
{
  MALLOC_INIT ();

  hfunc_t add_one_half = hfunc_make (2, 1, 0, 2);
  hfunc_t add_one = hfunc_make (1, 1, 0, 1);
  hfunc_t divide_by_two = hfunc_make (1, 0, 0, 2);
  hfunc_t divide_by_four = hfunc_make (1, 0, 0, 4);
  hfunc_t take_reciprocal = hfunc_make (0, 1, 1, 0);
  hfunc_t add_one_then_div_two = hfunc_make (1, 1, 0, 2);
  hfunc_t add_two_then_div_four = hfunc_make (1, 2, 0, 4);

  cf_t cf_13_11 = r2cf (13, 11);
  cf_t cf_22_7 = r2cf (22, 7);
  cf_t cf_sqrt2 = sqrt2_make ();

  cf_t cf_13_11_plus_1_2 = hfunc_apply (add_one_half, cf_13_11);
  cf_t cf_22_7_plus_1_2 = hfunc_apply (add_one_half, cf_22_7);
  cf_t cf_22_7_div_4 = hfunc_apply (divide_by_four, cf_22_7);

  /* The following two give the same result: */
  cf_t cf_sqrt2_div_2 = hfunc_apply (divide_by_two, cf_sqrt2);
  cf_t cf_1_div_sqrt2 = hfunc_apply (take_reciprocal, cf_sqrt2);
  assert (strcmp (cf2string (cf_sqrt2_div_2),
                  cf2string (cf_1_div_sqrt2)) == 0);

  /* The following three give the same result: */
  cf_t cf_2_plus_sqrt2_grouped_div_4 =
    hfunc_apply (add_two_then_div_four, cf_sqrt2);
  cf_t cf_half_of_1_plus_half_sqrt2 =
    hfunc_apply (add_one_then_div_two, cf_sqrt2_div_2);
  cf_t cf_half_of_1_plus_1_div_sqrt2 =
    hfunc_apply (divide_by_two,
                 hfunc_apply (add_one, cf_sqrt2_div_2));
  assert (strcmp (cf2string (cf_2_plus_sqrt2_grouped_div_4),
                  cf2string (cf_half_of_1_plus_half_sqrt2)) == 0);
  assert (strcmp (cf2string (cf_half_of_1_plus_half_sqrt2),
                  cf2string (cf_half_of_1_plus_1_div_sqrt2)) == 0);

  printf ("13/11 => %s\n", cf2string (cf_13_11));
  printf ("22/7 => %s\n", cf2string (cf_22_7));
  printf ("sqrt(2) => %s\n", cf2string (cf_sqrt2));
  printf ("13/11 + 1/2 => %s\n", cf2string (cf_13_11_plus_1_2));
  printf ("22/7 + 1/2 => %s\n", cf2string (cf_22_7_plus_1_2));
  printf ("(22/7)/4 => %s\n", cf2string (cf_22_7_div_4));
  printf ("sqrt(2)/2 => %s\n", cf2string (cf_sqrt2_div_2));
  printf ("1/sqrt(2) => %s\n", cf2string (cf_1_div_sqrt2));
  printf ("(2+sqrt(2))/4 => %s\n",
          cf2string (cf_2_plus_sqrt2_grouped_div_4));
  printf ("(1+sqrt(2)/2)/2 => %s\n",
          cf2string (cf_half_of_1_plus_half_sqrt2));
  printf ("(1+1/sqrt(2))/2 => %s\n",
          cf2string (cf_half_of_1_plus_1_div_sqrt2));

  return 0;
}

/*------------------------------------------------------------------*/
