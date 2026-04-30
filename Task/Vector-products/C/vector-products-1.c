#include "vec.h"

#define out_tst(a,b,c) \
({ \
out_vec("         a  =",                                 (a)   ,3); out_end(); \
out_vec("         b  =",                                 (b)   ,3); out_end(); \
out_vec("         c  =",                                 (c)   ,3); out_end(); \
out_vec("     a . b  =",            broadcast(3,dot3((a),(b))) ,3); out_end(); \
out_vec("     a x b  =",                      cross3((a),(b))  ,3); out_end(); \
out_vec("a . (b x c) =", broadcast(3,dot3((a),cross3((b),(c)))),3); out_end(); \
out_vec("a x (b x c) =",           cross3((a),cross3((b),(c))) ,3); out_end(); \
out_vec("    (a x 1) =",                      cross2((a),0x901),2); out_end(); \
out_vec("    (a x 0) =",                      cross2((a),0x900),2); out_end(); \
out_vec("    (b x 1) =",                      cross2((b),0x901),2); out_end(); \
out_vec("    (b x 0) =",                      cross2((b),0x900),2); out_end(); \
})

int main(int argc, char** argv)
{
        vec(flt,3) a = {   3,   4,   5 };
        vec(flt,3) b = {   4,   3,   5 };
        vec(flt,3) c = {  -5, -12, -13 };

        out_tst(a,b,c);
        exit(EXIT_SUCCESS);
}
