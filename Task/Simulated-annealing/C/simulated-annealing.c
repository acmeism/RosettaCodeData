#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#define VECSZ 100
#define STATESZ 64

typedef float floating_pt;
#define EXP expf
#define SQRT sqrtf

static floating_pt
randnum (void)
{
  return (floating_pt)
    ((double) (random () & 2147483647) / 2147483648.0);
}

static void
shuffle (uint8_t vec[], size_t i, size_t n)
{
  /* A Fisher-Yates shuffle of n elements of vec, starting at index
     i. */
  for (size_t j = 0; j != n; j += 1)
    {
      size_t k = i + j + (random () % (n - j));
      uint8_t xi = vec[i];
      uint8_t xk = vec[k];
      vec[i] = xk;
      vec[k] = xi;
    }
}

static void
init_s (uint8_t vec[VECSZ])
{
  for (uint8_t j = 0; j != VECSZ; j += 1)
    vec[j] = j;
  shuffle (vec, 1, VECSZ - 1);
}

static inline void
add_neighbor (uint8_t neigh[8],
              unsigned int *neigh_size,
              uint8_t neighbor)
{
  if (neighbor != 0)
    {
      neigh[*neigh_size] = neighbor;
      *neigh_size += 1;
    }
}

static void
neighborhood (uint8_t neigh[8],
              unsigned int *neigh_size,
              uint8_t city)
{
  /* Find all non-zero neighbor cities. */

  const uint8_t i = city / 10;
  const uint8_t j = city % 10;

  uint8_t c0 = 0;
  uint8_t c1 = 0;
  uint8_t c2 = 0;
  uint8_t c3 = 0;
  uint8_t c4 = 0;
  uint8_t c5 = 0;
  uint8_t c6 = 0;
  uint8_t c7 = 0;

  if (i < 9)
    {
      c0 = (10 * (i + 1)) + j;
      if (j < 9)
        c1 = (10 * (i + 1)) + (j + 1);
      if (0 < j)
        c2 = (10 * (i + 1)) + (j - 1);
    }
  if (0 < i)
    {
      c3 = (10 * (i - 1)) + j;
      if (j < 9)
        c4 = (10 * (i - 1)) + (j + 1);
      if (0 < j)
        c5 = (10 * (i - 1)) + (j - 1);
    }
  if (j < 9)
    c6 = (10 * i) + (j + 1);
  if (0 < j)
    c7 = (10 * i) + (j - 1);

  *neigh_size = 0;
  add_neighbor (neigh, neigh_size, c0);
  add_neighbor (neigh, neigh_size, c1);
  add_neighbor (neigh, neigh_size, c2);
  add_neighbor (neigh, neigh_size, c3);
  add_neighbor (neigh, neigh_size, c4);
  add_neighbor (neigh, neigh_size, c5);
  add_neighbor (neigh, neigh_size, c6);
  add_neighbor (neigh, neigh_size, c7);
}

static floating_pt
distance (uint8_t m, uint8_t n)
{
  const uint8_t im = m / 10;
  const uint8_t jm = m % 10;
  const uint8_t in = n / 10;
  const uint8_t jn = n % 10;
  const int di = (int) im - (int) in;
  const int dj = (int) jm - (int) jn;
  return SQRT ((di * di) + (dj * dj));
}

static floating_pt
path_length (uint8_t vec[VECSZ])
{
  floating_pt len = distance (vec[0], vec[VECSZ - 1]);
  for (size_t j = 0; j != VECSZ - 1; j += 1)
    len += distance (vec[j], vec[j + 1]);
  return len;
}

static void
swap_s_elements (uint8_t vec[], uint8_t u, uint8_t v)
{
  size_t j = 1;
  size_t iu = 0;
  size_t iv = 0;
  while (iu == 0 || iv == 0)
    {
      if (vec[j] == u)
        iu = j;
      else if (vec[j] == v)
        iv = j;
      j += 1;
    }
  vec[iu] = v;
  vec[iv] = u;
}

static void
update_s (uint8_t vec[])
{
  const uint8_t u = 1 + (random () % (VECSZ - 1));
  uint8_t neighbors[8];
  unsigned int num_neighbors;
  neighborhood (neighbors, &num_neighbors, u);
  const uint8_t v = neighbors[random () % num_neighbors];
  swap_s_elements (vec, u, v);
}

static inline void
copy_s (uint8_t dst[VECSZ], uint8_t src[VECSZ])
{
  memcpy (dst, src, VECSZ * (sizeof src[0]));
}

static void
trial_s (uint8_t trial[VECSZ], uint8_t vec[VECSZ])
{
  copy_s (trial, vec);
  update_s (trial);
}

static floating_pt
temperature (floating_pt kT, unsigned int kmax, unsigned int k)
{
  return kT * (1 - ((floating_pt) k / (floating_pt) kmax));
}

static floating_pt
probability (floating_pt delta_E, floating_pt T)
{
  floating_pt prob;
  if (delta_E < 0)
    prob = 1;
  else if (T == 0)
    prob = 0;
  else
    prob = EXP (-(delta_E / T));
  return prob;
}

static void
show (unsigned int k, floating_pt T, floating_pt E)
{
  printf (" %7u %7.1f %13.5f\n", k, (double) T, (double) E);
}

static void
simulate_annealing (floating_pt kT,
                    unsigned int kmax,
                    uint8_t s[VECSZ])
{
  uint8_t trial[VECSZ];

  unsigned int kshow = kmax / 10;
  floating_pt E = path_length (s);
  for (unsigned int k = 0; k != kmax + 1; k += 1)
    {
      const floating_pt T = temperature (kT, kmax, k);
      if (k % kshow == 0)
        show (k, T, E);
      trial_s (trial, s);
      const floating_pt E_trial = path_length (trial);
      const floating_pt delta_E = E_trial - E;
      const floating_pt P = probability (delta_E, T);
      if (P == 1 || randnum () <= P)
        {
          copy_s (s, trial);
          E = E_trial;
        }
    }
}

static void
display_path (uint8_t vec[VECSZ])
{
  for (size_t i = 0; i != VECSZ; i += 1)
    {
      const uint8_t x = vec[i];
      printf ("%2u ->", (unsigned int) x);
      if ((i % 8) == 7)
        printf ("\n");
      else
        printf (" ");
    }
  printf ("%2u\n", vec[0]);
}

int
main (void)
{
  char state[STATESZ];
  uint32_t seed[1];
  int status = getentropy (&seed[0], sizeof seed[0]);
  if (status < 0)
    seed[0] = 1;
  initstate (seed[0], state, STATESZ);

  floating_pt kT = 1.0;
  unsigned int kmax = 1000000;

  uint8_t s[VECSZ];
  init_s (s);

  printf ("\n");
  printf ("   kT: %f\n", (double) kT);
  printf ("   kmax: %u\n", kmax);
  printf ("\n");
  printf ("       k       T          E(s)\n");
  printf (" -----------------------------\n");
  simulate_annealing (kT, kmax, s);
  printf ("\n");
  display_path (s);
  printf ("\n");
  printf ("Final E(s): %.5f\n", (double) path_length (s));
  printf ("\n");

  return 0;
}
