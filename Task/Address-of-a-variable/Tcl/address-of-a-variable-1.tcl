package require critcl
# This code assumes an ILP32 architecture, like classic x86 or VAX.
critcl::cproc peek {int addr} int {
    union {
       int i;
       int *a;
    } u;

    u.i = addr;
    return *u.a;
}
critcl::cproc poke {int addr int value} void {
    union {
        int i;
        int *a;
    } u;

    u.i = addr;
    *u.a = value;
}
package provide poker 1.0
