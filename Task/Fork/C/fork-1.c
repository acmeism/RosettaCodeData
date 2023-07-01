#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <err.h>

int main()
{
	pid_t pid;

	if (!(pid = fork())) {
		usleep(10000);
		printf("\tchild process: done\n");
	} else if (pid < 0) {
		err(1, "fork error");
	} else {
		printf("waiting for child %d...\n", (int)pid);
		printf("child %d finished\n", (int)wait(0));
	}

	return 0;
}
