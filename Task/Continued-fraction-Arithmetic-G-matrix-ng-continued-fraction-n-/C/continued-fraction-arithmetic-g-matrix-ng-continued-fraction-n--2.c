/*------------------------------------------------------------------*/
/* For C23 without need of a garbage collector. */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

/*------------------------------------------------------------------*/

/* We need consistent definitions of division and remainder. Let us
   set those here. For convenience (because C provides it), we will
   use truncation towards zero. */
#define DIV(a, b) ((a) / (b))
#define REM(a, b) ((a) % (b))

/* Choose a memory allocator. (Ideally one should check for NULL
   return values, but for this pedagogical example let us skip
   that.) */
#define MALLOC_INIT() do { } while (0) /* A no-op. */
#define MALLOC malloc
#define REALLOC realloc
#define FREE free

/*------------------------------------------------------------------*/
/* The basics. */

/* The integer type. */
typedef long long int integer;

/* A generator is a recursive type that forms a tree. */
typedef struct generator *generator_t;
typedef struct generator_list *generator_list_t;
struct generator_list
{
  generator_t car;
  generator_list_t cdr;
};
typedef void generator_func_t (integer *workspace,
                               generator_list_t sources,
                               bool *term_exists,
                               integer *term);
struct generator
{
  generator_func_t *run;     /* What does the work. */
  size_t worksize;           /* The size of the workspace. */
  integer *initial;          /* The initial value of the workspace. */
  integer *workspace;        /* The workspace itself. */
  generator_list_t sources;  /* The sources of input terms. */
};

/* Reinitializes a generator. (Needed because there is no
   memoization.) */
void generator_t_initialize (generator_t);

/* Frees a generator. */
void generator_t_free (generator_t);

/*------------------------------------------------------------------*/
/* A function to print the output of a generator in a form suitable
   for eqn/troff. */

void ftroff_generator_output (FILE *, generator_t, int max_terms);

/*------------------------------------------------------------------*/
/* Some functions to make generators. */

/* For a rational number. */
generator_t r2cf_make (integer n, integer d);

/* For the square root of 2. */
generator_t sqrt2_make (void);

/* For a homographic function. */
generator_t hfunc_make (integer a1, integer a, integer b1, integer b,
                        generator_t source);

/*------------------------------------------------------------------*/
/* Implementations. */

void
generator_t_initialize (generator_t gen)
{
  if (gen != NULL)
    {
      memcpy (gen->workspace, gen->initial,
              gen->worksize * sizeof (integer));
      for (generator_list_t p = gen->sources; p != NULL; p = p->cdr)
        generator_t_initialize (p->car);
    }
}

void
generator_t_free (generator_t gen)
{
  if (gen != NULL)
    {
      FREE (gen->initial);
      FREE (gen->workspace);

      generator_list_t p = gen->sources;
      while (p != NULL)
        {
          generator_list_t q = p->cdr;
          generator_t_free (p->car);
          FREE (p);
          p = q;
        }

      FREE (gen);
    }
}

/*  -    -    -    -    -    -    -    -    -    -    -    -    -   */

void
ftroff_generator_output (FILE *outf, generator_t gen, int max_terms)
{
  assert (1 <= max_terms);

  generator_t_initialize (gen);

  int terms_count = 0;
  int sep = 0;
  bool done = false;
  while (!done)
    {
      if (terms_count == max_terms)
        {
          fprintf (outf, ", ~ ... ~ ]");
          done = true;
        }
      else
        {
          bool term_exists;
          integer term;
          gen->run (gen->workspace, gen->sources, &term_exists,
                    &term);
          if (term_exists)
            {
              switch (sep)
                {
                case 0:
                  fprintf (outf, "[ ^ ");
                  sep = 1;
                  break;
                case 1:
                  fprintf (outf, "; ^ ");
                  sep = 2;
                  break;
                default:
                  fprintf (outf, " , ");
                  break;
                }
              fprintf (outf, "%jd", (intmax_t) term);
              terms_count += 1;
            }
          else
            {
              fprintf (outf, "^ ] ");
              done = true;
            }
        }
    }

  generator_t_initialize (gen);
}

/*  -    -    -    -    -    -    -    -    -    -    -    -    -   */

static void
r2cf_run (integer *workspace,
          [[maybe_unused]] generator_list_t sources,
          bool *term_exists, integer *term)
{
  integer d = workspace[1];
  *term_exists = (d != 0);
  if (*term_exists)
    {
      integer n = workspace[0];
      integer q = DIV (n, d);
      integer r = REM (n, d);
      workspace[0] = d;
      workspace[1] = r;
      *term = q;
    }
}

generator_t
r2cf_make (integer n, integer d)
{
  generator_t gen = MALLOC (sizeof (*gen));
  gen->run = r2cf_run;
  gen->worksize = 2;
  gen->initial = MALLOC (gen->worksize * sizeof (integer));
  gen->workspace = MALLOC (gen->worksize * sizeof (integer));
  gen->initial[0] = n;
  gen->initial[1] = d;
  memcpy (gen->workspace, gen->initial,
          gen->worksize * sizeof (integer));
  gen->sources = NULL;
  return gen;
}

/*  -    -    -    -    -    -    -    -    -    -    -    -    -   */

static void
sqrt2_run (integer *workspace,
           [[maybe_unused]] generator_list_t sources,
           bool *term_exists, integer *term)
{
  *term_exists = true;
  *term = workspace[0];
  workspace[0] = 2;
}

generator_t
sqrt2_make (void)
{
  generator_t gen = MALLOC (sizeof (*gen));
  gen->run = sqrt2_run;
  gen->worksize = 1;
  gen->initial = MALLOC (gen->worksize * sizeof (integer));
  gen->workspace = MALLOC (gen->worksize * sizeof (integer));
  gen->initial[0] = 1;
  memcpy (gen->workspace, gen->initial,
          gen->worksize * sizeof (integer));
  gen->sources = NULL;
  return gen;
}

/*  -    -    -    -    -    -    -    -    -    -    -    -    -   */

static void
hfunc_take_term (integer *workspace, generator_list_t sources)
{
  generator_t src = sources->car;
  bool term_exists1;
  integer term1;
  src->run (src->workspace, src->sources, &term_exists1, &term1);
  integer a1 = workspace[0];
  integer b1 = workspace[2];
  if (term_exists1)
    {
      integer a = workspace[1];
      integer b = workspace[3];
      workspace[0] = a + (a1 * term1);
      workspace[1] = a1;
      workspace[2] = b + (b1 * term1);
      workspace[3] = b1;
    }
  else
    {
      workspace[1] = a1;
      workspace[3] = b1;
    }
}

static void
hfunc_run (integer *workspace, generator_list_t sources,
           bool *term_exists, integer *term)
{
  bool done = false;
  while (!done)
    {
      integer b1 = workspace[2];
      integer b = workspace[3];
      if (b1 == 0 && b == 0)
        {
          *term_exists = false;
          done = true;
        }
      else
        {
          integer a1 = workspace[0];
          integer a = workspace[1];
          if (b1 != 0 && b != 0)
            {
              integer q1 = DIV (a1, b1);
              integer q = DIV (a, b);
              if (q1 == q)
                {
                  workspace[0] = b1;
                  workspace[1] = b;
                  workspace[2] = a1 - (b1 * q);
                  workspace[3] = a - (b * q);
                  *term_exists = true;
                  *term = q;
                  done = true;
                }
              else
                hfunc_take_term (workspace, sources);
            }
          else
            hfunc_take_term (workspace, sources);
        }
    }
}

generator_t
hfunc_make (integer a1, integer a, integer b1, integer b,
            generator_t source)
{
  generator_t gen = MALLOC (sizeof (*gen));
  gen->run = hfunc_run;
  gen->worksize = 4;
  gen->initial = MALLOC (gen->worksize * sizeof (integer));
  gen->workspace = MALLOC (gen->worksize * sizeof (integer));
  gen->initial[0] = a1;
  gen->initial[1] = a;
  gen->initial[2] = b1;
  gen->initial[3] = b;
  memcpy (gen->workspace, gen->initial,
          gen->worksize * sizeof (integer));
  gen->sources = MALLOC (sizeof (struct generator_list));
  gen->sources->car = source;
  gen->sources->cdr = NULL;
  return gen;
}

/*------------------------------------------------------------------*/
/* Components of the demonstration. */

#define MAX_TERMS 20
#define GOES_TO " ~ -> ~ "
#define START_EQ ".EQ\n"
#define STOP_EQ "\n.EN\n"
#define NEW_LINE "\n"

void
ftroff_rational_number (FILE *outf, integer n, integer d)
{
  generator_t gen = r2cf_make (n, d);
  fprintf (outf, "%s %jd over %jd %s",
           START_EQ, (intmax_t) n, (intmax_t) d, GOES_TO);
  ftroff_generator_output (outf, gen, MAX_TERMS);
  fprintf (outf, "%s%s", STOP_EQ, NEW_LINE);
  generator_t_free (gen);
}

void
ftroff_sqrt2 (FILE *outf)
{
  generator_t gen = sqrt2_make ();
  fprintf (outf, "%s sqrt 2 %s", START_EQ, GOES_TO);
  ftroff_generator_output (outf, gen, MAX_TERMS);
  fprintf (outf, "%s%s", STOP_EQ, NEW_LINE);
  generator_t_free (gen);
}

void
ftroff_hfunc_of_rational_number (FILE *outf,
                                 const char *expr,
                                 integer a1, integer a,
                                 integer b1, integer b,
                                 integer n, integer d)
{
  generator_t gen = hfunc_make (a1, a, b1, b, r2cf_make (n, d));
  fprintf (outf, "%s %s %s", START_EQ, expr, GOES_TO);
  ftroff_generator_output (outf, gen, MAX_TERMS);
  fprintf (outf, "%s%s", STOP_EQ, NEW_LINE);
  generator_t_free (gen);
}

void
ftroff_hfunc_of_sqrt2 (FILE *outf, const char *expr,
                       integer a1, integer a, integer b1, integer b)
{
  generator_t gen = hfunc_make (a1, a, b1, b, sqrt2_make ());
  fprintf (outf, "%s %s %s", START_EQ, expr, GOES_TO);
  ftroff_generator_output (outf, gen, MAX_TERMS);
  fprintf (outf, "%s%s", STOP_EQ, NEW_LINE);
  generator_t_free (gen);
}

void
ftroff_complicated (FILE *outf)
{
  /* This function demonstrates a more complicated nesting of
     generators. */

  /* gen1 = 1/sqrt(2) */
  generator_t gen1 = hfunc_make (0, 1, 1, 0, sqrt2_make ());

  /* gen2 = 1 + gen1 */
  generator_t gen2 = hfunc_make (1, 1, 0, 1, gen1);

  /* gen = gen2 / 2 */
  generator_t gen = hfunc_make (1, 0, 0, 2, gen2);

  fprintf (outf, "%s {1 ~ + ~ { 1 over { sqrt 2 } }} over 2 %s",
           START_EQ, GOES_TO);
  ftroff_generator_output (outf, gen, MAX_TERMS);
  fprintf (outf, "%s%s", STOP_EQ, NEW_LINE);

  generator_t_free (gen);
}

/*------------------------------------------------------------------*/

int
main (void)
{
  MALLOC_INIT ();

  FILE *outf = stdout;

  /* Output is for "eqn -Tpdf | groff -Tpdf -P-p6i,5.5i -ms" */

  fprintf (outf, ".nr PO 0.25i\n");
  fprintf (outf, ".nr HM 0.25i\n");
  fprintf (outf, ".ps 14\n");

  ftroff_rational_number (outf, 13, 11);
  ftroff_rational_number (outf, 22, 7);
  ftroff_sqrt2 (outf);
  ftroff_hfunc_of_rational_number
    (outf, "{ 13 over 11 } ~ + ~ { 1 over 2 }",
     2, 1, 0, 2, 13, 11);
  ftroff_hfunc_of_rational_number
    (outf, "{ 22 over 7 } ~ + ~ { 1 over 2 }",
     2, 1, 0, 2, 22, 7);
  ftroff_hfunc_of_rational_number
    (outf, "{ ^ {\"\\s-3\" 22 over 7 \"\\s+3\"}} over 4",
     1, 0, 0, 4, 22, 7);
  ftroff_hfunc_of_sqrt2
    (outf, "{ sqrt 2 } over 2", 1, 0, 0, 2);
  ftroff_hfunc_of_sqrt2
    (outf, "1 over { sqrt 2 }", 0, 1, 1, 0);
  ftroff_hfunc_of_sqrt2
    (outf, "{ 2 ~ + ~ { sqrt 2 }} over 4", 1, 2, 0, 4);
  ftroff_complicated (outf);

  return 0;
}

/*------------------------------------------------------------------*/
