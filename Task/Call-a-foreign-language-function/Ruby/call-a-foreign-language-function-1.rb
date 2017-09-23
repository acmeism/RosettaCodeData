/* rc_strdup.c */
#include <stdlib.h>   /* free() */
#include <string.h>   /* strdup() */
#include <ruby.h>

static VALUE
rc_strdup(VALUE obj, VALUE str_in)
{
    VALUE str_out;
    char *c, *d;

    /*
     * Convert Ruby value to C string.  May raise TypeError if the
     * value isn't a string, or ArgumentError if it contains '\0'.
     */
    c = StringValueCStr(str_in);

    /* Call strdup() and perhaps raise Errno::ENOMEM. */
    d = strdup(c);
    if (d == NULL)
	rb_sys_fail(NULL);

    /* Convert C string to Ruby string. */
    str_out = rb_str_new_cstr(d);
    free(d);
    return str_out;
}

void
Init_rc_strdup(void)
{
    VALUE mRosettaCode = rb_define_module("RosettaCode");
    rb_define_module_function(mRosettaCode, "strdup", rc_strdup, 1);
}
