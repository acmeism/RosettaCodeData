#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>

//
// high address________
//            |________| length
//  T *p ---> |___ ____| most recent value
//            |____ ___|
//                     |
//            |___ ____
//            |_____ __|
//            |________| oldest value
//  low address
//

static size_t hv__align(void const *p, size_t z) {
	return z + ((sizeof(z) - (((size_t)p + z) % sizeof(z))) % sizeof(z));
}

static size_t hvlen(void const *p, size_t z) {
	return *(size_t *)((char *)p + hv__align(p, z));
}

static void *hv__malloc(size_t z) {
	size_t const m = z + (2 * sizeof(z));
	void  *const p = malloc(m);
	if(p) {
		*(size_t *)((char *)p + hv__align(p, z)) = 1;
		return p;
	}
	perror("");
	abort();
}

static void *hv__realloc(void *p, size_t z, size_t n) {
	size_t const u = hvlen(p, z);
	size_t const o = (n > 1) ? n * z : z;
	size_t const g = (u > 1) ? u * z : z;
	size_t const m = o + (2 * sizeof(z));
	void  *const b = (char *)p - (g - z);
	p = realloc(b, m);
	if(p) {
		p = (char *)p + (o - z);
		*(size_t *)((char *)p + hv__align(p, z)) = n;
		return p;
	}
	perror("");
	abort();
}

static void *hvfree(void const *p, size_t z) {
	if(p) {
		size_t u = hvlen(p, z);
		size_t const o = (u > 1) ? u * z : z;
		free((char *)p - (o - z));
	}
	return NULL;
}

static void *hv(void const *p, size_t z) {
	return p ? hv__realloc((void *)p, z, hvlen(p, z) + 1) : hv__malloc(z);
}
#define HV__TYPE(T,V) \
	T: *(T *)(V = (hv)((V), sizeof(*(V))))
#define hv(V) _Generic(*(V), \
	HV__TYPE(         char     , (V)), \
	HV__TYPE(         short    , (V)), \
	HV__TYPE(         int      , (V)), \
	HV__TYPE(         long     , (V)), \
	HV__TYPE(         long long, (V)), \
	HV__TYPE(unsigned char     , (V)), \
	HV__TYPE(unsigned short    , (V)), \
	HV__TYPE(unsigned int      , (V)), \
	HV__TYPE(unsigned long     , (V)), \
	HV__TYPE(unsigned long long, (V)), \
	HV__TYPE(float             , (V)), \
	HV__TYPE(double            , (V)), \
	HV__TYPE(long double       , (V))  \
)

static void const *hvundo(void const *p, size_t z) {
	return p ? hv__realloc((void *)p, z, hvlen(p, z) - 1) : p;
}
#define hvundo(V)  (V = (hvundo)((V), sizeof(*(V))))

#define hvfree(V)  (hvfree)((V), sizeof(*(V)))
#define hvlen(V)   (hvlen)((V), sizeof(*(V)))

int main(int argc, char **argv) {
	char     const *c = NULL;
	unsigned const *u = NULL;
	double   const *d = NULL;
	hv(c) = '1';
	hv(c) = '2';
	hv(c) = '3';
	hv(u) = 1;
	hv(u) = 21;
	hvundo(u);
	hv(u) = 12;
	hv(u) = 123;
	hv(d) = 1.23;
	hv(d) = 2.31;
	hv(d) = 3.12;
	printf("current values        : '%c', %u, %g", *c, *u, *d);
	putchar('\n');
	printf("char value history    :");
	for(size_t n = hvlen(c), i = 0; i < n; i++) {
		printf(" [%zu]  '%c',", i, c[-i]);
	}
	putchar('\n');
	printf("unsigned value history:");
	for(size_t n = hvlen(u), i = 0; i < n; i++) {
		printf(" [%zu] %4u,", i, u[-i]);
	}
	putchar('\n');
	printf("double value history  :");
	for(size_t n = hvlen(d), i = 0; i < n; i++) {
		printf(" [%zu] %4g,", i, d[-i]);
	}
	putchar('\n');
	hvfree(c);
	hvfree(u);
	hvfree(d);
	return 0;
}
