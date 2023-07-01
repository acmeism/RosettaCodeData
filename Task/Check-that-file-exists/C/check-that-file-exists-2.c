#include <gadget/gadget.h>

LIB_GADGET_START

/* input.txt = check_file.c
   docs = tests */

Main
    Print "tests/check_file.c is a regular file? %s\n", Exist_file("tests/check_file.c") ? "yes" : "no";
    Print "tests is a directory? %s\n",                 Exist_dir("tests") ? "yes" : "no";
    Print "some.txt is a regular file? %s\n",           Exist_file("some.txt") ? "yes" : "no";
    Print "/tests is a directory? %s\n",                Exist_dir("/tests") ? "yes" : "no";
End
