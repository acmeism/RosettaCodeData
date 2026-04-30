# syntax: GAWK -f SCOPE_MODIFIERS.AWK
BEGIN {
# All variables in AWK are considered global
    a = 1 # global
    b = 2 # global
#   c is undefined
#
    x(a) # call function in default namespace
    printf("a='%s' c='%s'\n\n",a,c)
#
# A recent addition to GAWK is namespace
# The default namespace is "awk"
#
# All variables in the default namespace may be referenced by
#   name or awk::name
#
# All variables in another namespace must be referenced as
#   namespace::name
#
# For example to reference function x in the default namespace use
#   x() or awk::x()
#
# To reference function x in the "test" namespace use test::x()
#
# Let's test the two functions named "x" which are shown below
#
    awk::x(22) # call function in default namespace
    printf("a='%s' c='%s'\n\n",a,c)
    test::x(22) # call function in another namespace
    printf("a='%s' c='%s'\n\n",a,c)
    exit(0)
}
# Variables are:
# - local to functions when specified as arguments
# - passed by value except arrays which are passed by reference
#
function x(a,  c) {
    printf("inside awk::x() a='%s'\n",a)
    a = c = 9
    printf("inside awk::x() a='%s'\n",a)
}
@namespace "test"
function x(a,  c) {
    printf("inside test::x() a='%s'\n",a)
    a = c = 9
    printf("inside test::x() a='%s'\n",a)
}
