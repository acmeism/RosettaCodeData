#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <ctype.h>

typedef struct { char * s; size_t alloc_len; } string;

typedef struct {
    char *pat, *repl;
    int terminate;
} rule_t;

typedef struct {
    int n;
    rule_t *rules;
    char *buf;
} ruleset_t;

void ruleset_del(ruleset_t *r)
{
    if (r->rules) free(r->rules);
    if (r->buf) free(r->buf);
    free(r);
}

string * str_new(const char *s)
{
    int l = strlen(s);
    string *str = malloc(sizeof(string));
    str->s = malloc(l + 1);
    strcpy(str->s, s);
    str->alloc_len = l + 1;
    return str;
}

void str_append(string *str, const char *s, int len)
{
    int l = strlen(str->s);
    if (len == -1) len = strlen(s);

    if (str->alloc_len < l + len + 1) {
        str->alloc_len = l + len + 1;
        str->s = realloc(str->s, str->alloc_len);
    }
    memcpy(str->s + l, s, len);
    str->s[l + len] = '\0';
}

/* swap content of dest and src, and truncate src string */
void str_transfer(string *dest, string *src)
{
    size_t tlen = dest->alloc_len;
    dest->alloc_len = src->alloc_len;
    src->alloc_len = tlen;

    char *ts = dest->s;
    dest->s = src->s;
    src->s = ts;
    src->s[0] = '\0';
}

void str_del(string *s)
{
    if (s->s) free(s->s);
    free(s);
}

void str_markov(string *str, ruleset_t *r)
{
    int i, j, sl, pl;
    int changed = 0, done = 0;
    string *tmp = str_new("");

    while (!done) {
        changed = 0;
        for (i = 0; !done && !changed && i < r->n; i++) {
            pl = strlen(r->rules[i].pat);
            sl = strlen(str->s);
            for (j = 0; j < sl; j++) {
                if (strncmp(str->s + j, r->rules[i].pat, pl))
                    continue;
                str_append(tmp, str->s, j);
                str_append(tmp, r->rules[i].repl, -1);
                str_append(tmp, str->s + j + pl, -1);

                str_transfer(str, tmp);
                changed = 1;

                if (r->rules[i].terminate)
                    done = 1;
                break;
            }
        }
        if (!changed) break;
    }
    str_del(tmp);
    return;
}

ruleset_t* read_rules(const char *name)
{
    struct stat s;
    char *buf;
    size_t i, j, k, tmp;
    rule_t *rules = 0;
    int n = 0; /* number of rules */

    int fd = open(name, O_RDONLY);
    if (fd == -1) return 0;

    fstat(fd, &s);
    buf = malloc(s.st_size + 2);
    read(fd, buf, s.st_size);
    buf[s.st_size] = '\n';
    buf[s.st_size + 1] = '\0';
    close(fd);

    for (i = j = 0; buf[i] != '\0'; i++) {
        if (buf[i] != '\n') continue;

        /* skip comments */
        if (buf[j] == '#' || i == j) {
            j = i + 1;
            continue;
        }

        /* find the '->' */
        for (k = j + 1; k < i - 3; k++)
            if (isspace(buf[k]) && !strncmp(buf + k + 1, "->", 2))
                break;

        if (k >= i - 3) {
            printf("parse error: no -> in %.*s\n", i - j, buf + j);
            break;
        }

        /* left side: backtrack through whitespaces */
        for (tmp = k; tmp > j && isspace(buf[--tmp]); );
        if (tmp < j) {
            printf("left side blank? %.*s\n", i - j, buf + j);
            break;
        }
        buf[++tmp] = '\0';

        /* right side */
        for (k += 3; k < i && isspace(buf[++k]););
        buf[i] = '\0';

        rules = realloc(rules, sizeof(rule_t) * (1 + n));
        rules[n].pat = buf + j;

        if (buf[k] == '.') {
            rules[n].terminate = 1;
            rules[n].repl = buf + k + 1;
        } else {
            rules[n].terminate = 0;
            rules[n].repl = buf + k;
        }
        n++;

        j = i + 1;
    }

    ruleset_t *r = malloc(sizeof(ruleset_t));
    r->buf = buf;
    r->rules = rules;
    r->n = n;
    return r;
}

int test_rules(const char *s, const char *file)
{
    ruleset_t * r = read_rules(file);
    if (!r) return 0;
    printf("Rules from '%s' ok\n", file);

    string *ss = str_new(s);
    printf("text:     %s\n", ss->s);

    str_markov(ss, r);
    printf("markoved: %s\n", ss->s);

    str_del(ss);
    ruleset_del(r);

    return printf("\n");
}

int main()
{
    /* rule 1-5 are files containing rules from page top */
    test_rules("I bought a B of As from T S.", "rule1");
    test_rules("I bought a B of As from T S.", "rule2");
    test_rules("I bought a B of As W my Bgage from T S.", "rule3");
    test_rules("_1111*11111_", "rule4");
    test_rules("000000A000000", "rule5");

    return 0;
}
