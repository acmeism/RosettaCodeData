#include <execinfo.h>

void *frames[128];
int len = backtrace(frames, 128);
char **symbols = backtrace_symbols(frames, len);
for (int i = 0; i < len; ++i) {
    NSLog(@"%s", symbols[i]);
}
free(symbols);
