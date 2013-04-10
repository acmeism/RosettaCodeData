#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

pthread_mutex_t condm = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
int bang = 0;

#define WAITBANG() do { \
   pthread_mutex_lock(&condm); \
   while( bang == 0 ) \
   { \
      pthread_cond_wait(&cond, &condm); \
   } \
   pthread_mutex_unlock(&condm); } while(0);\

void *t_enjoy(void *p)
{
  WAITBANG();
  printf("Enjoy\n");
  pthread_exit(0);
}

void *t_rosetta(void *p)
{
  WAITBANG();
  printf("Rosetta\n");
  pthread_exit(0);
}

void *t_code(void *p)
{
  WAITBANG();
  printf("Code\n");
  pthread_exit(0);
}

typedef void *(*threadfunc)(void *);
int main()
{
   int i;
   pthread_t a[3];
   threadfunc p[3] = {t_enjoy, t_rosetta, t_code};

   for(i=0;i<3;i++)
   {
     pthread_create(&a[i], NULL, p[i], NULL);
   }
   sleep(1);
   bang = 1;
   pthread_cond_broadcast(&cond);
   for(i=0;i<3;i++)
   {
     pthread_join(a[i], NULL);
   }
}
