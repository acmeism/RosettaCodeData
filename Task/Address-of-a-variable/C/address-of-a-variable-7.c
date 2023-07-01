#include <cstring>
inline float read_as_float(int const& i) { float f; memcpy(&f, &i, sizeof(f)); return f; }
int i = 0x0a112233;
float f = read_as_float(i);
