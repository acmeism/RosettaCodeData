#include <stdarg.h>

#define MAX(A,...) ({ inline __typeof__ (A) _max_(__typeof__ (A) a, ...) {\
  va_list l; int i,c; const char *s = #__VA_ARGS__; __typeof__ (A) max = a;\
  __typeof__ (A) t;\
  for(c=1;*s!=0;s++) if (*s==',') c++;\
  va_start(l, a);\
  for(i=0;i<=c;i++) {\
  if ((t=va_arg(l,__typeof__ (A))) > max) max = t;\
  }\
  va_end(l); return max;\
}\
_max_((A),__VA_ARGS__);\
})
