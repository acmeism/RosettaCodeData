#include <stdio.h>

#define if2(a, b) switch(((a)) + ((b)) * 2) { case 3:
#define else00	break; case 0:	/* both false */
#define else10	break; case 1:	/* true, false */
#define else01	break; case 2:	/* false, true */
#define else2	break; default: /* anything not metioned */
#define fi2	}		/* stupid end bracket */

int main()
{
	int i, j;
	for (i = 0; i < 3; i++) for (j = 0; j < 3; j++) {
		printf("%d %d: ", i, j);
		if2 (i == 1, j == 1)
			printf("both\n");
		else10
			printf("left\n");
		else01
			printf("right\n");
		else00 { /* <-- bracket is optional, flaw */,
			printf("neither\n");
			if2 (i == 2, j == 2)
				printf("\tis 22");
				printf("\n"); /* flaw: this is part of if2! */
			else2
				printf("\tnot 22\n");
			fi2				
		}
		fi2
	}

	return 0;
}
