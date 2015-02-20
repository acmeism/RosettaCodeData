#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/mman.h>

typedef int (*f_int)();

#define TAG 0xdeadbeef
int _tmpl() {
	volatile int x = TAG;
	return x * x;
}

#define PROT (PROT_EXEC | PROT_WRITE)
#define FLAGS (MAP_PRIVATE | MAP_ANONYMOUS)
f_int dupf(int v)
{
	size_t len = (void*)dupf - (void*)_tmpl;
	f_int ret = mmap(NULL, len, PROT, FLAGS, 0, 0);
	char *p;
	if(ret == MAP_FAILED) {
		perror("mmap");
		exit(-1);
	}
	memcpy(ret, _tmpl, len);
	for (p = (char*)ret; p < (char*)ret + len - sizeof(int); p++)
		if (*(int *)p == TAG) *(int *)p = v;
	return ret;
}

int main()
{
	f_int funcs[10];
	int i;
	for (i = 0; i < 10; i++) funcs[i] = dupf(i);

	for (i = 0; i < 9; i++)
		printf("func[%d]: %d\n", i, funcs[i]());

	return 0;
}
