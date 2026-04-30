#ifdef _MSC_VER
#define INLINE __force_inline __flatten __declspec(nothrow) __declspec(noalias) inline
#else
#define INLINE __attribute__((always_inline,flatten,nothrow,const)) inline
#endif
