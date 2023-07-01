#define array_concat(T,a1,a2,returned) \
    T[a1.length()+a2.length()] returned; \
    { \
    for(int i = 0; i < a1.length(); i++){ \
        returned[i] = a1[i]; \
    } \
    for(int i = 0; i < a2.length(); i++){ \
        returned[i+a1.length()] = a2[i]; \
    } \
}
