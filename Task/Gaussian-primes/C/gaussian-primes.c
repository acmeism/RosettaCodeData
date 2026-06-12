#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

typedef struct icplx {
	int re, im;
} icplx;

int norm(icplx c)
{
	return c.re * c.re + c.im * c.im;
}

bool isprime(int n)
{
	if (n < 2) return false;
	else if (n % 2 == 0) return n == 2;
	for (int d = 3; d * d <= n; d += 2) {
		if (n % d == 0) return false;
	}
	return true;
}

bool is_gaussian_prime(icplx c)
{
	int re = abs(c.re), im = abs(c.im);
	if (re == 0) return (im & 3) == 3 && isprime(im);
	else if (im == 0) return (re & 3) == 3 && isprime(re);
	else return isprime(norm(c));
}

void with_gaussian_primes(int radius, void (*fn)(icplx))
{
	int max_norm = radius * radius;
	for (int x = -radius; x <= radius; x++)
		for (int y = -radius; y <= radius; y++) {
			icplx c = (icplx){.re = x, .im = y};
			if (norm(c) < max_norm && is_gaussian_prime(c))
				fn(c);
		}
}

void print_complex(icplx c)
{
	static int count = 0;
	if (c.re == 0) printf("% 2di", c.im);
	else if (c.im == 0) printf("% 2d", c.re);
	else printf("% 2d%+2di", c.re, c.im);
	printf("%c", (count++ % 10 == 9) ? '\n' : '\t');
}

FILE *plot_file;

void plot_point(icplx c)
{
	unsigned x = c.re * 8 + 500, y = c.im * 8 + 500;
	fprintf(plot_file, "<circle cx='%u' cy='%u' r='4' fill='cyan' />\n", x, y);
}

int main(void)
{
	puts("Gaussian primes within radius 10 from origin of complex plane:");
	with_gaussian_primes(10, print_complex);
	putchar('\n');
	FILE *f = fopen("plot.svg", "w+");
	fputs("<svg xmlns='http://www.w3.org/2000/svg' width='1000' height='1000'>\n", f);
	fputs("<rect style='width: 100%; height: 100%; fill: black' />\n", f);
	fputs("<line x1='0' y1='500' x2='1000' y2='500' stroke='white' stroke-width='2' />\n", f);
	fputs("<line x1='500' y1='0' x2='500' y2='1000' stroke='white' stroke-width='2' />\n", f);
	plot_file = f;
	with_gaussian_primes(50, plot_point);
	fputs("</svg>\n", f);
	fclose(f);
}
