#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define PI  (3.14159265358979323846)

#define EARTH_RADIUS_NM  (3440.8)

struct airport {
	double      distance;
	double      bearing;

	int         id;
	char const *name;
	char const *city;
	char const *country;
	char const *iata;
	char const *icao;
	double      latitude;
	double      longitude;
	double      altitude;
	double      timezone;
	char const *dst;
	char const *tz;
	char const *type;
	char const *source;
};

static size_t n_airports = 0;
static struct airport *airport = NULL;

static void print_header(size_t cnlen, size_t anlen) {
	static const char dashes[] = "--------------------------------------------------------------------------------";
	printf("%.8s | %.4s | %.4s | %-*s | %-*s\n",
		"DISTANCE",
		"BEAR",
		"ICAO",
		cnlen, "COUNTRY",
		anlen, "AIRPORT"
	);
	printf("%.8s-+-%.4s-+-%.4s-+-%.*s-+-%.*s\n",
		dashes,
		dashes,
		dashes,
		cnlen, dashes,
		anlen, dashes
	);
}

static void print_airport(struct airport *airp, size_t cnlen, size_t anlen) {
	printf("%8.1f | %4.0f | %-4s | %-*s | %-*s\n",
		airp->distance,
		airp->bearing,
		airp->icao,
		cnlen, airp->country,
		anlen, airp->name
	);
}

#define RADIANS  * PI / 180
#define DEGREES  * 180 / PI

static double sq(double x) {
	return x * x;
}

static double distance(double lat1, double lon1, double lat2, double lon2) {
	double rlat1 = lat1 RADIANS;
	double rlat2 = lat2 RADIANS;
	double dlat  = (lat2 - lat1) RADIANS;
	double dlon  = (lon2 - lon1) RADIANS;
	double a     = sq(sin(dlat/2)) + cos(rlat1) * cos(rlat2) * sq(sin(dlon/2));
	double c     = 2 * atan2(sqrt(a), sqrt(1 - a));
	return EARTH_RADIUS_NM * c;
}

static double bearing(double lat1, double lon1, double lat2, double lon2) {
	double rlat1 = lat1 RADIANS;
	double rlat2 = lat2 RADIANS;
	double dlon  = (lon2 - lon1) RADIANS;
	double x     = cos(rlat1) * sin(rlat2) - sin(rlat1) * cos(rlat2) * cos(dlon);
	double y     = sin(dlon) * cos(rlat2);
	double theta = atan2(y, x);
	return fmod(theta DEGREES + 360, 360);
}

static int compare_by_distance(void const *p1, void const *p2) {
	struct airport const *a1 = *(struct airport const **)p1;
	struct airport const *a2 = *(struct airport const **)p2;
	return (a1->distance < a2->distance) ? -1 : (a1->distance > a2->distance) ? +1 : 0;
}
static struct airport **order_by_distance(double latitude, double longitude) {
	struct airport **list = malloc(sizeof(*list) * n_airports);
	for(int i = 0; i < n_airports; i++) {
		airport[i].distance = distance(latitude, longitude, airport[i].latitude, airport[i].longitude);
		airport[i].bearing  = bearing (latitude, longitude, airport[i].latitude, airport[i].longitude);
		list[i] = &airport[i];
	}
	qsort(list, n_airports, sizeof(*list), compare_by_distance);
	return list;
}

static char **split(char *s, int c) {
	char **v = malloc(sizeof(*v));
	if(!v) {
		perror("");
		abort();
	}
	size_t n = 0;
	for(char *t; *s; s = t) {
		t = strchr(s, c);
		if(!t) {
			t = s + strlen(s);
		} else {
			*t++ = '\0';
		}
		if(*s) {
			size_t i = n++;
			v = realloc(v, sizeof(*v) * (n + 1));
			if(!v) {
				perror("");
				abort();
			}
			v[i] = s;
		}
	}
	v[n] = NULL;
	return v;
}

static unsigned int_or_zero(char *s) {
	return (s && *s && strcmp(s, "\\N")) ? atoi(s) : 0;
}

static double dbl_or_zero(char *s) {
	return (s && *s && strcmp(s, "\\N")) ? atof(s) : 0;
}

static char *str_or_null(char *s) {
	size_t n = strlen(s);
	if((n > 0) && s[n-1] == '"') s[n-1] = '\0';
	if(*s == '"') s++;
	return (s && *s && strcmp(s, "\\N")) ? s : "NULL";
}

static void load_airports(char *s) {
	char **line = split(s, '\n');
	if(line) {
		for(size_t i = 0; line[i] != NULL; i++) {
			char **field = split(line[i], ',');
			if(!field) continue;
			size_t j = n_airports++;
			airport = realloc(airport, sizeof(*airport) * n_airports);
			if(!airport) {
				perror("");
				abort();
			}
			struct airport *airp = &airport[j];
			airp->id        = int_or_zero(field[0]);
			airp->name      = str_or_null(field[1]);
			airp->city      = str_or_null(field[2]);
			airp->country   = str_or_null(field[3]);
			airp->iata      = str_or_null(field[4]);
			airp->icao      = str_or_null(field[5]);
			airp->latitude  = dbl_or_zero(field[6]);
			airp->longitude = dbl_or_zero(field[7]);
			airp->altitude  = dbl_or_zero(field[8]);
			airp->timezone  = dbl_or_zero(field[9]);
			airp->dst       = str_or_null(field[10]);
			airp->tz        = str_or_null(field[11]);
			airp->type      = str_or_null(field[12]);
			airp->source    = str_or_null(field[13]);
			free(field);
		}
		free(line);
	}
}

static char *ingest(FILE *in, char const *filename) {
	size_t n = 0;
	size_t z = BUFSIZ-1;
	char  *content = malloc(BUFSIZ);
	if(!content) {
		perror("");
		abort();
	}
	do {
		size_t u = fread(content + n, 1, z - n, in);
		if(ferror(in)) {
			free(content);
			perror(filename);
			return NULL;
		}
		n += u;
		if(n == z) {
			z += BUFSIZ;
			content = realloc(content, z + 1);
			if(!content) {
				perror(filename);
				abort();
			}
		}
	} while(!feof(in))
		;
	content[n] = '\0';
	return content;
}

#define DEFER(DEFER_pre,DEFER_cond,DEFER_post) \
	for(int DEFER##__LINE__ = 1; DEFER##__LINE__; DEFER##__LINE__ = 0) \
		for(DEFER_pre; DEFER##__LINE__ && (DEFER_cond); (DEFER_post), DEFER##__LINE__ = 0)

int main(int argc, char **argv) {
	int failed;
	char *airports_dat = NULL;
	char const *infile = "airports.dat";
	DEFER(FILE *in = fopen(infile, "r"),
		!(failed = !in) || (perror(infile), 0),
		fclose(in)
	) {
		airports_dat = ingest(in, infile);
		if((failed = !airports_dat)) break;
		load_airports(airports_dat);
		if((failed = !airport)) break;
	}
	if(!failed) for(;;) {
		double latitude, longitude;
		fputs("Enter latitude,longitude> ", stdout);
		fflush(stdout);
		if(scanf("%lf,%lf", &latitude, &longitude) != 2) break;
		putchar('\n');
		struct airport **list = order_by_distance(latitude, longitude);
		size_t cnlen = 0;
		size_t anlen = 0;
		for(size_t n, i = 0; i < 20; i++) {
			if((n = strlen(list[i]->country)) > cnlen) cnlen = n;
			if((n = strlen(list[i]->name)) > anlen) anlen = n;
		}
		print_header(cnlen, anlen);
		for(size_t i = 0; i < 20; i++) {
			print_airport(list[i], cnlen, anlen);
		}
		putchar('\n');
		free(list);
	}
	free(airport);
	free(airports_dat);
	return failed ? EXIT_FAILURE : EXIT_SUCCESS;
}

//
