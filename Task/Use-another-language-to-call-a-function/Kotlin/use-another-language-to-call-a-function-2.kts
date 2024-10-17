#ifndef KONAN_LIBQUERY_H
#define KONAN_LIBQUERY_H
#ifdef __cplusplus
extern "C" {
#endif
typedef unsigned char   libQuery_KBoolean;
typedef char            libQuery_KByte;
typedef unsigned short  libQuery_KChar;
typedef short           libQuery_KShort;
typedef int             libQuery_KInt;
typedef long long       libQuery_KLong;
typedef float           libQuery_KFloat;
typedef double          libQuery_KDouble;
typedef void*           libQuery_KNativePtr;
struct libQuery_KType;
typedef struct libQuery_KType libQuery_KType;

typedef struct {
  /* Service functions. */
  void (*DisposeStablePointer)(libQuery_KNativePtr ptr);
  void (*DisposeString)(const char* string);
  libQuery_KBoolean (*IsInstance)(libQuery_KNativePtr ref, const libQuery_KType* type);

  /* User functions. */
  struct {
    struct {
      libQuery_KInt (*query)(void* data, void* length);
    } root;
  } kotlin;
} libQuery_ExportedSymbols;
extern libQuery_ExportedSymbols* libQuery_symbols(void);
#ifdef __cplusplus
}  /* extern "C" */
#endif
#endif  /* KONAN_LIBQUERY_H */
