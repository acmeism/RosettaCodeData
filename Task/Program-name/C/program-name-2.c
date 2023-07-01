#include <stdio.h>

int main()
{
	printf("This code was in file %s in function %s, at line %d\n",\
		__FILE__, __FUNCTION__, __LINE__);
	return 0;
}
