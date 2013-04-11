...
#include "silly.h"

struct sDog {
   float max_stick_weight;
   int   isTired;
   int   isAnnoyed;
};

static struct sDog lazyDog = { 4.0, 0,0 };

/* define functions used by the functions in header as static */
static int RunToStick( )
{...
}
/* define functions declared in the header file. */

void JumpOverTheDog(int numberOfTimes)
{ ...
   lazyDog.isAnnoyed = TRUE;
}
int PlayFetchWithDog( float weightOfStick )
{ ...
   if(weightOfStick < lazyDog.max_stick_weight){...
}
