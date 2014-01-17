#ifndef SILLY_H
#define SILLY_H
#include "intefaceAbs.h"

typedef struct sillyStruct *Silly;
extern Silly NewSilly( double, const char *);
extern AbsCls Silly_Instance(void *);

#endif
