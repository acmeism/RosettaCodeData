#include "vec.hpp"

using i32x3 = vec<int,3>;

int main(int argc, char** argv)
{
        i32x3 a = {  3 ,  4 ,  5 };
        i32x3 b = {  4 ,  3 ,  5 };
        i32x3 c = { -5, -12, -13 };

        i32x3 d = cross3(a,b);
        i32x3 e = triplevec3(a,b,c);

        a.println("a           = ");
        b.println("b           = ");
        c.println("c           = "); eol();

        printf("    (a . b) = %d", dot(a,b)); eol();
        d.println("    (a x b) = ");
        printf("a . (b x c) = %d", triplesca3(a,b,c)); eol();
        e.println("a x (b x c) = ");
        exit(EXIT_SUCCESS);
}
