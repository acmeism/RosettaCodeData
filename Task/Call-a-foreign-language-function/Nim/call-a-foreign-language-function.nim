proc strcmp(a, b: cstring): cint {.importc: "strcmp", nodecl.}
echo strcmp("abc", "def")
echo strcmp("hello", "hello")

proc printf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

var x = "foo"
printf("Hello %d %s!\n", 12, x)
