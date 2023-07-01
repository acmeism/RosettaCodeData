/* query-rb.c */
#include <stdlib.h>
#include <ruby.h>

/*
 * QueryPointer() uses Ruby and may raise a Ruby error.  Query() is a
 * C wrapper around QueryPointer() that loads Ruby, sets QueryPointer,
 * and protects against Ruby errors.
 */
int (*QueryPointer)(char *, size_t *) = NULL;

static int in_bad_exit = 0;

static void
do_at_exit(void)
{
    RUBY_INIT_STACK;

    if (!in_bad_exit)
	ruby_cleanup(0);
}

static void
bad_exit(int state)
{
    in_bad_exit = 1;
    ruby_stop(state);  /* Clean up Ruby and exit the process. */
}

static void
require_query(void)
{
    static int done = 0;
    int state;

    if (done)
	return;
    done = 1;

    ruby_init();
    atexit(do_at_exit);
    ruby_init_loadpath();  /* needed to require 'fiddle' */

    /* Require query.rb in current directory. */
    rb_eval_string_protect("require_relative 'query'", &state);
    if (!state && !QueryPointer)
	rb_eval_string_protect("fail 'missing QueryPointer'", &state);
    if (state)
	bad_exit(state);  /* Ruby will report the error. */
}

struct args {
    char *data;
    size_t *length;
    int result;
};

static VALUE
Query1(VALUE v) {
    struct args *a = (struct args *)v;
    a->result = QueryPointer(a->data, a->length);
    return Qnil;
}

int
Query(char *data, size_t *length)
{
    struct args a;
    int state;
    RUBY_INIT_STACK;

    require_query();

    /* Call QueryPointer(), protect against errors. */
    a.data = data;
    a.length = length;
    rb_protect(Query1, (VALUE)&a, &state);
    if (state)
	bad_exit(state);
    return a.result;
}
