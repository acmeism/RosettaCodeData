#include <assert.h>

float max(unsigned int count, float values[]) {
     assert(count > 0);
     size_t idx;
     float themax = values[0];
     for(idx = 1; idx < count; ++idx) {
          themax = values[idx] > themax ? values[idx] : themax;
     }
     return themax;
}
