#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <sys/wait.h>
#include <err.h>

typedef int (*intfunc)(int);
typedef void (*pfunc)(int*, int);

pfunc partial(intfunc fin)
{
	pfunc f;
	static int idx = 0;
	char cc[256], lib[256];
	FILE *fp;
	sprintf(lib, "/tmp/stuff%d.so", ++idx);
	sprintf(cc, "cc -pipe -x c -shared -o %s -", lib);

	fp = popen(cc, "w");
	fprintf(fp, "#define t typedef\xat int _i,*i;t _i(*__)(_i);__ p =(__)%p;"
		"void _(i _1, _i l){while(--l>-1)l[_1]=p(l[_1]);}", fin);
	fclose(fp);

	*(void **)(&f) = dlsym(dlopen(lib, RTLD_LAZY), "_");
	unlink(lib);
	return f;
}

int square(int a)
{
	return a * a;
}

int dbl(int a)
{
	return a + a;
}

int main()
{
	int x[] = { 1, 2, 3, 4 };
	int y[] = { 1, 2, 3, 4 };
	int i;

	pfunc f = partial(square);
	pfunc g = partial(dbl);

	printf("partial square:\n");
	f(x, 4);
	for (i = 0; i < 4; i++) printf("%d\n", x[i]);

	printf("partial double:\n");
	g(y, 4);
	for (i = 0; i < 4; i++) printf("%d\n", y[i]);

	return 0;
}
