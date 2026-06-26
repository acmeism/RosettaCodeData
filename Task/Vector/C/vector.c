#include "arrays.h"

/* arbitrary type test macro */
#define out_tst(a,b) \
({ \
        out_vec("vec a           : ",(a      ),2); out_end(); \
        out_vec("vec b           : ",(    b  ),2); out_end(); \
        out_vec("a + b           : ",(a + b  ),2); out_end(); \
        out_vec("a - b           : ",(a - b  ),2); out_end(); \
        out_vec("a * 3           : ",(a * 3  ),2); out_end(); \
        out_vec("b / 2.5         : ",(b / 2.5),2); out_end(); \
})

int main(int argc, char** argv)
{
        vec(2,flt) a = { 3 * cos(  pi/6), 3 * sin(  pi/6) };
        vec(2,flt) b = { 5 * cos(2*pi/3), 5 * sin(2*pi/3) };

        out_tst(a,b);
        return EXIT_SUCCESS;
}
