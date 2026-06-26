#include "arrays.h"

#define out_tst(a,b,c) \
({ \
out_vec("         a  =",                                 (a)   ,3); out_end(); \
out_vec("         b  =",                                 (b)   ,3); out_end(); \
out_vec("         c  =",                                 (c)   ,3); out_end(); \
out_vec("     a . b  =",            broadcast(3,dot3((a),(b))) ,3); out_end(); \
out_vec("     a x b  =",                      cross3((a),(b))  ,3); out_end(); \
out_vec("a . (b x c) =", broadcast(3,dot3((a),cross3((b),(c)))),3); out_end(); \
out_vec("a x (b x c) =",           cross3((a),cross3((b),(c))) ,3); out_end(); \
})

int main(int argc, char** argv)
{
        vec(3,flt) a = {   3,   4,   5 };
        vec(3,flt) b = {   4,   3,   5 };
        vec(3,flt) c = {  -5, -12, -13 };

        out_tst(a,b,c);
        exit(EXIT_SUCCESS);
}
