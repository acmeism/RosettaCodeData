#include <assert.h>

float max(unsigned int count, float values[]) {
     assert(count > 0);
     unsigned int idx;
     float themax = values[0];
     for(i = 1; i < count; ++i) {
          themax = values[i] > themax ? values[i] : themax;
     }
     return themax;
}
