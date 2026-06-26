#include "arrays.h"

#define fout_num(stream,prefix,number,suffix) fprintf(stream, "%s%+e%s", prefix, (double)number, suffix)
#define out_num(number) fout_num(stdout,"",number,"")

int main(int argc, char** argv)
{
        vec(3,flt) a = { 1,  3, -5};
        arr(3,flt) b = { 4, -2, -1};

        out_num(dot3(a, b)); out_end();

        exit(EXIT_SUCCESS);
}
