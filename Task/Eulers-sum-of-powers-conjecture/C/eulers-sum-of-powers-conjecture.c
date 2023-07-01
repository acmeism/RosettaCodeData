// Alexander Maximov, July 2nd, 2015
#include <stdio.h>
#include <time.h>
typedef long long mylong;

void compute(int N, char find_only_one_solution)
{	const int M = 30;   /* x^5 == x modulo M=2*3*5 */
	int a, b, c, d, e;
	mylong s, t, max, *p5 = (mylong*)malloc(sizeof(mylong)*(N+M));

	for(s=0; s < N; ++s)
		p5[s] = s * s, p5[s] *= p5[s] * s;
	for(max = p5[N - 1]; s < (N + M); p5[s++] = max + 1);

	for(a = 1; a < N; ++a)
	for(b = a + 1; b < N; ++b)
	for(c = b + 1; c < N; ++c)
	for(d = c + 1, e = d + ((t = p5[a] + p5[b] + p5[c]) % M); ((s = t + p5[d]) <= max); ++d, ++e)
	{	for(e -= M; p5[e + M] <= s; e += M); /* jump over M=30 values for e>d */
		if(p5[e] == s)
		{	printf("%d %d %d %d %d\r\n", a, b, c, d, e);
			if(find_only_one_solution) goto onexit;
		}
	}
onexit:
	free(p5);
}

int main(void)
{
	int tm = clock();
	compute(250, 0);
	printf("time=%d milliseconds\r\n", (int)((clock() - tm) * 1000 / CLOCKS_PER_SEC));
	return 0;
}
