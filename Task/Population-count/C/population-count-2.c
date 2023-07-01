#if defined(__POPCNT__) && defined(__GNUC__) && (__GNUC__> 4 || (__GNUC__== 4 && __GNUC_MINOR__> 1))
#define HAVE_BUILTIN_POPCOUNTLL
#endif
static uint64_t bitcount64(uint64_t b) {
  b -= (b >> 1) & 0x5555555555555555;
  b = (b & 0x3333333333333333) + ((b >> 2) & 0x3333333333333333);
  b = (b + (b >> 4)) & 0x0f0f0f0f0f0f0f0f;
  return (b * 0x0101010101010101) >> 56;
}
/* For 32-bit, an 8-bit table may or may not be a little faster */
static uint32_t bitcount32(uint32_t b) {
  b -= (b >> 1) & 0x55555555;
  b = (b & 0x33333333) + ((b >> 2) & 0x33333333);
  b = (b + (b >> 4)) & 0x0f0f0f0f;
  return (b * 0x01010101) >> 24;
}
