#include <  stdlib.h>
#include <  stdint.h>
#include <  stddef.h>
#include < stdbool.h>
#include <stdalign.h>
#include <    math.h>

/* default floating point type */
typedef float flt;

typedef vec (flt,4) quat(flt);
typedef quat(flt  ) rotor;
typedef quat(flt  ) screw;
typedef vec (flt,8) motor;

#define motor_rotor(m) *(rotor*)&(m)[0]
#define motor_screw(m) *(screw*)&(m)[4]
