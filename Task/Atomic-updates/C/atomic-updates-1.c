#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>

#define N_BUCKETS 15

pthread_mutex_t bucket_mutex[N_BUCKETS];
int buckets[N_BUCKETS];

pthread_t equalizer;
pthread_t randomizer;

void transfer_value(int from, int to, int howmuch)
{
  bool swapped = false;

  if ( (from == to) || ( howmuch < 0 ) ||
       (from < 0 ) || (to < 0) || (from >= N_BUCKETS) || (to >= N_BUCKETS) ) return;

  if ( from > to ) {
    int temp1 = from;
    from = to;
    to = temp1;
    swapped = true;
    howmuch = -howmuch;
  }

  pthread_mutex_lock(&bucket_mutex[from]);
  pthread_mutex_lock(&bucket_mutex[to]);

  if ( howmuch > buckets[from] && !swapped )
    howmuch = buckets[from];
  if ( -howmuch > buckets[to] && swapped )
    howmuch = -buckets[to];

  buckets[from] -= howmuch;
  buckets[to] += howmuch;

  pthread_mutex_unlock(&bucket_mutex[from]);
  pthread_mutex_unlock(&bucket_mutex[to]);
}

void print_buckets()
{
  int i;
  int sum=0;

  for(i=0; i < N_BUCKETS; i++) pthread_mutex_lock(&bucket_mutex[i]);
  for(i=0; i < N_BUCKETS; i++) {
    printf("%3d ", buckets[i]);
    sum += buckets[i];
  }
  printf("= %d\n", sum);
  for(i=0; i < N_BUCKETS; i++) pthread_mutex_unlock(&bucket_mutex[i]);
}

void *equalizer_start(void *t)
{
  for(;;) {
    int b1 = rand()%N_BUCKETS;
    int b2 = rand()%N_BUCKETS;
    int diff = buckets[b1] - buckets[b2];
    if ( diff < 0 )
      transfer_value(b2, b1, -diff/2);
    else
      transfer_value(b1, b2, diff/2);
  }
  return NULL;
}

void *randomizer_start(void *t)
{
  for(;;) {
    int b1 = rand()%N_BUCKETS;
    int b2 = rand()%N_BUCKETS;
    int diff = rand()%(buckets[b1]+1);
    transfer_value(b1, b2, diff);
  }
  return NULL;
}

int main()
{
  int i, total=0;

  for(i=0; i < N_BUCKETS; i++) pthread_mutex_init(&bucket_mutex[i], NULL);

  for(i=0; i < N_BUCKETS; i++) {
    buckets[i] = rand() % 100;
    total += buckets[i];
    printf("%3d ", buckets[i]);
  }
  printf("= %d\n", total);

  // we should check if these succeeded
  pthread_create(&equalizer, NULL, equalizer_start, NULL);
  pthread_create(&randomizer, NULL, randomizer_start, NULL);

  for(;;) {
    sleep(1);
    print_buckets();
  }

  // we do not provide a "good" way to stop this run, so the following
  // is never reached indeed...
  for(i=0; i < N_BUCKETS; i++) pthread_mutex_destroy(bucket_mutex+i);
  return EXIT_SUCCESS;
}
