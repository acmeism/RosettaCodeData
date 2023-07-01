#include <stdlib.h>
#include <stdio.h>

void
subleq(int *code)
{
	int ip = 0, a, b, c, nextIP;
	char ch;
	while(0 <= ip) {
		nextIP = ip + 3;
		a = code[ip];
		b = code[ip + 1];
		c = code[ip + 2];
		if(a == -1) {
			scanf("%c", &ch);
			code[b] = (int)ch;
		} else if(b == -1) {
			printf("%c", (char)code[a]);
		} else {
			code[b] -= code[a];
			if(code[b] <= 0)
				nextIP = c;
		}
		ip = nextIP;
	}
}

void
processFile(char *fileName)
{
	int *dataSet, i, num;
	FILE *fp = fopen(fileName, "r");
	fscanf(fp, "%d", &num);
	dataSet = (int *)malloc(num * sizeof(int));
	for(i = 0; i < num; i++)
		fscanf(fp, "%d", &dataSet[i]);
	fclose(fp);
	subleq(dataSet);
}

int
main(int argC, char *argV[])
{
	if(argC != 2)
		printf("Usage : %s <subleq code file>\n", argV[0]);
	else
		processFile(argV[1]);
	return 0;
}
