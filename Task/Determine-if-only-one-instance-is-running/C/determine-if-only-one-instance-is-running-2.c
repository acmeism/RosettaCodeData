#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
/* unistd for sleep */

void sigint_handler(int sig)
{
   fprintf(stderr, "Caught signal %d.\n", sig);
   unlink("/tmp/MyUniqueName");
   /* exit() is not safe in a signal handler, use _exit() */
   _exit(1);
}

int main()
{
   struct sigaction act;
   int myfd;

   myfd = open("/tmp/MyUniqueName", O_CREAT|O_EXCL);
   if ( myfd < 0 )
   {
      fprintf(stderr, "I am already running!\n");
      exit(1);
   }
   act.sa_handler = sigint_handler;
   sigemptyset(&act.sa_mask);
   act.sa_flags = 0;
   sigaction(SIGINT, &act, NULL);
   /* here the real code of the app*/
   sleep(20);
   /* end of the app */
   unlink("/tmp/MyUniqueName"); close(myfd);
   return 0;
}
