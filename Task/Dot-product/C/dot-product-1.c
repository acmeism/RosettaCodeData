#include "array.h"

#define dot(a,b,t,n,i) \
({ \
        static_assert((isarray(a) || isvector(a)), \
        "ERROR: dot - a is not of array or vector type!"); \
        static_assert((isarray(b) || isvector(b)), \
        "ERROR: dot - b is not of array or vector type!"); \
        t _dst = (t)i; \
        size_t len = (size_t)llabs((ssize_t)n); \
        len = MIN(MIN(!isarray(a) ? vec_countof(a) : countof(a), \
                      !isarray(b) ? vec_countof(b) : countof(b)), \
                  (ssize_t)n>0?len:0); \
        _Pragma("omp simd reduction(+:_dst)") \
        for(size_t j = 0; j < len; j++) \
               _dst += (t)((a)[j]) * (t)((b)[j]); \
        _dst; \
})

typedef double real;

#define dot3(a,b) dot(a,b,real,3,0)
#define dot4(a,b) dot(a,b,real,4,0)

#define out_eol puts("")
#define fout_num(stream,prefix,number,suffix) fprintf(stream, "%s%+e%s", prefix, (double)number, suffix)
#define out_num(number) fout_num(stdout,"",number,"")

int main(int argc, char** argv)
{
        vec(real,3) a = { 1,  3, -5};
        arr(real,3) b = { 4, -2, -1};

        out_num(dot3(a, b)); out_eol;

        exit(EXIT_SUCCESS);
}
