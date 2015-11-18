#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define err(...) fprintf(stderr, ## __VA_ARGS__), exit(1)

/* We create a dynamic string with a few functions which make modifying
 * the string and growing a bit easier */
typedef struct {
    char *data;
    size_t alloc;
    size_t length;
} dstr;

inline int dstr_space(dstr *s, size_t grow_amount)
{
    return s->length + grow_amount < s->alloc;
}

int dstr_grow(dstr *s)
{
    s->alloc *= 2;
    char *attempt = realloc(s->data, s->alloc);

    if (!attempt) return 0;
    else s->data = attempt;

    return 1;
}

dstr* dstr_init(const size_t to_allocate)
{
    dstr *s = malloc(sizeof(dstr));
    if (!s) goto failure;

    s->length = 0;
    s->alloc  = to_allocate;
    s->data   = malloc(s->alloc);

    if (!s->data) goto failure;

    return s;

failure:
    if (s->data) free(s->data);
    if (s) free(s);
    return NULL;
}

void dstr_delete(dstr *s)
{
    if (s->data) free(s->data);
    if (s) free(s);
}

dstr* readinput(FILE *fd)
{
    static const size_t buffer_size = 4096;
    char buffer[buffer_size];

    dstr *s = dstr_init(buffer_size);
    if (!s) goto failure;

    while (fgets(buffer, buffer_size, fd)) {
        while (!dstr_space(s, buffer_size))
            if (!dstr_grow(s)) goto failure;

        strncpy(s->data + s->length, buffer, buffer_size);
        s->length += strlen(buffer);
    }

    return s;

failure:
    dstr_delete(s);
    return NULL;
}

void dstr_replace_all(dstr *story, const char *replace, const char *insert)
{
    const size_t replace_l = strlen(replace);
    const size_t insert_l  = strlen(insert);
    char *start = story->data;

    while ((start = strstr(start, replace))) {
        if (!dstr_space(story, insert_l - replace_l))
            if (!dstr_grow(story)) err("Failed to allocate memory");

        if (insert_l != replace_l) {
            memmove(start + insert_l, start + replace_l, story->length -
                    (start + replace_l - story->data));

            /* Remember to null terminate the data so we can utilize it
             * as we normally would */
            story->length += insert_l - replace_l;
            story->data[story->length] = 0;
        }

        memmove(start, insert, insert_l);
    }
}

void madlibs(dstr *story)
{
    static const size_t buffer_size = 128;
    char insert[buffer_size];
    char replace[buffer_size];

    char *start,
         *end = story->data;

    while (start = strchr(end, '<')) {
        if (!(end = strchr(start, '>'))) err("Malformed brackets in input");

        /* One extra for current char and another for nul byte */
        strncpy(replace, start, end - start + 1);
        replace[end - start + 1] = '\0';

        printf("Enter value for field %s: ", replace);

        fgets(insert, buffer_size, stdin);
        const size_t il = strlen(insert) - 1;
        if (insert[il] == '\n')
            insert[il] = '\0';

        dstr_replace_all(story, replace, insert);
    }
    printf("\n");
}

int main(int argc, char *argv[])
{
    if (argc < 2) return 0;

    FILE *fd = fopen(argv[1], "r");
    if (!fd) err("Could not open file: '%s\n", argv[1]);

    dstr *story = readinput(fd); fclose(fd);
    if (!story) err("Failed to allocate memory");

    madlibs(story);
    printf("%s\n", story->data);
    dstr_delete(story);
    return 0;
}
