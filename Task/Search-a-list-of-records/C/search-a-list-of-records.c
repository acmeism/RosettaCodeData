#include <stdint.h> /* intptr_t */
#include <stdio.h>
#include <stdlib.h> /* bsearch */
#include <string.h>
#include <search.h> /* lfind */

#define LEN(x) (sizeof(x) / sizeof(x[0]))

struct cd {
    char *name;
    double population;
};

/* Return -1 if name could not be found */
int search_get_index_by_name(const char *name, const struct cd *data, const size_t data_length,
        int (*cmp_func)(const void *, const void *))
{
    struct cd key = { (char *) name, 0 };
    struct cd *match = bsearch(&key, data, data_length,
            sizeof(struct cd), cmp_func);

    if (match == NULL)
        return -1;
    else
        return ((intptr_t) match - (intptr_t) data) / sizeof(struct cd);
}

/* Return -1 if no matching record can be found */
double search_get_pop_by_name(const char *name, const struct cd *data, size_t data_length,
        int (*cmp_func)(const void *, const void *))
{
    struct cd key = { (char *) name, 0 };
    struct cd *match = lfind(&key, data, &data_length,
            sizeof(struct cd), cmp_func);

    if (match == NULL)
        return -1;
    else
        return match->population;
}

/* Return NULL if no value satisfies threshold */
char* search_get_pop_threshold(double pop_threshold, const struct cd *data, size_t data_length,
        int (*cmp_func)(const void *, const void *))
{
    struct cd key = { NULL, pop_threshold };
    struct cd *match = lfind(&key, data, &data_length,
            sizeof(struct cd), cmp_func);

    if (match == NULL)
        return NULL;
    else
        return match->name;
}

int cd_nameChar_cmp(const void *a, const void *b)
{
    struct cd *aa = (struct cd *) a;
    struct cd *bb = (struct cd *) b;
	
	int i,len = strlen(aa->name);

	for(i=0;i<len;i++)
		if(bb->name[i]!=aa->name[i])
			return -1;
	return 0;
}

int cd_name_cmp(const void *a, const void *b)
{
    struct cd *aa = (struct cd *) a;
    struct cd *bb = (struct cd *) b;
    return strcmp(bb->name, aa->name);
}

int cd_pop_cmp(const void *a, const void *b)
{
    struct cd *aa = (struct cd *) a;
    struct cd *bb = (struct cd *) b;
    return bb->population >= aa->population;
}

int main(void)
{
    const struct cd citydata[] = {
        { "Lagos", 21 },
        { "Cairo", 15.2 },
        { "Kinshasa-Brazzaville", 11.3 },
        { "Greater Johannesburg", 7.55 },
        { "Mogadishu", 5.85 },
        { "Khartoum-Omdurman", 4.98 },
        { "Dar Es Salaam", 4.7 },
        { "Alexandria", 4.58 },
        { "Abidjan", 4.4 },
        { "Casablanca", 3.98 }
    };

    const size_t citydata_length = LEN(citydata);

    printf("%d\n", search_get_index_by_name("Dar Es Salaam", citydata, citydata_length, cd_name_cmp));
    printf("%s\n", search_get_pop_threshold(5, citydata, citydata_length, cd_pop_cmp));
    printf("%lf\n", search_get_pop_by_name("A", citydata, citydata_length, cd_nameChar_cmp));

    return 0;
}
