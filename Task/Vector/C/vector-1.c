#include "vec.h"

/* arbitrary type test macro */
#define out_tst(a,b) \
({ \
        out_vec("Vec a           : ",(a      ),2); out_end(); \
        out_vec("Vec b           : ",(    b  ),2); out_end(); \
        out_vec("a + b           : ",(a + b  ),2); out_end(); \
        out_vec("a - b           : ",(a - b  ),2); out_end(); \
        out_vec("a * 3           : ",(a * 3  ),2); out_end(); \
        out_vec("b / 2.5         : ",(b / 2.5),2); out_end(); \
})

int main(int argc, char** argv)
{
        vec(flt,2) a = { 3 * cos(  pi/6), 3 * sin(  pi/6) };
        vec(flt,2) b = { 5 * cos(2*pi/3), 5 * sin(2*pi/3) };

        out_tst(a,b);
        return EXIT_SUCCESS;
}
