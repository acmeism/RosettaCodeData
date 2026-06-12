#include "quat.h"

#define out_tst(q,d) \
({ \
  quat(flt) qd = { d, 0.0, 0.0, 0.0 }; \
    printf("               d      = [ %+e ]\n", d); \
  out_quat("               q[0]   = ",  (q)[0]); out_end(); \
    printf("             ||q[0]|| = [ %+e ]\n", quat_norm((q)[0])); \
  out_quat("               q[1]   = ",  (q)[1]); out_end(); \
    printf("             ||q[1]|| = [ %+e ]\n", quat_norm((q)[1])); \
  out_quat("               q[2]   = ",  (q)[2]); out_end(); \
    printf("             ||q[2]|| = [ %+e ]\n", quat_norm((q)[2])); \
  out_quat("              -q[0]   = ", -(q)[0]); out_end(); \
  out_quat("               q[0]*  = ", quat_conj((q)[0])); out_end(); \
  out_quat("        d    + q[0]   = ", q[0] + qd); out_end(); \
  out_quat("        q[1] + q[2]   = ", (q)[1] + (q)[2]); out_end(); \
  out_quat("        q[2] + q[1]   = ", (q)[2] + (q)[1]); out_end(); \
  out_quat("        d    * q[0]   = ", q[0] * d); out_end(); \
  out_quat("(d, 0, 0, 0) * q[0]   = ", quat_mul(qd,(q)[0])); out_end(); \
  out_quat("        q[1] * q[2]   = ", quat_mul((q)[1], (q)[2])); out_end(); \
  out_quat("        q[2] * q[1]   = ", quat_mul((q)[2], (q)[1])); out_end(); \
})

int main()
{
       flt  d    = 7.0;
  quat(flt) q[3] = {{ 1.0, 2.0, 3.0, 4.0 },
                    { 2.0, 3.0, 4.0, 5.0 },
                    { 3.0, 4.0, 5.0, 6.0 }};

  out_tst(q,d);
  exit(EXIT_SUCCESS);
}
