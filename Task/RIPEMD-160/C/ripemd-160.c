#ifndef RMDsize
#define RMDsize 160
#endif

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#if RMDsize == 128
#include "rmd128.h"
#include "rmd128.c"  /* Added to remove errors during compilation */
#elif RMDsize == 160
#include "rmd160.h"
#include "rmd160.c"  /* Added to remove errors during compilation */
#endif
