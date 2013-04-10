#ifndef INTERFACE_ABS
#define INTERFACE_ABS

typedef struct sAbstractCls *AbsCls;

typedef struct sAbstractMethods {
    int         (*method1)(AbsCls c, int a);
    const char *(*method2)(AbsCls c, int b);
    void        (*method3)(AbsCls c, double d);
} *AbstractMethods, sAbsMethods;

struct sAbstractCls {
    AbstractMethods  klass;
    void     *instData;
};

#define ABSTRACT_METHODS( cName, m1, m2, m3 ) \
    static sAbsMethods cName ## _Iface = { &m1, &m2, &m3 }; \
    AbsCls cName ## _Instance( void *clInst) { \
        AbsCls ac = malloc(sizeof(struct sAbstractCls)); \
        if (ac) { \
            ac->klass = &cName ## _Iface; \
            ac->instData = clInst; \
        }\
        return ac; }

#define Abs_Method1( c, a) (c)->klass->method1(c, a)
#define Abs_Method2( c, b) (c)->klass->method2(c, b)
#define Abs_Method3( c, d) (c)->klass->method3(c, d)
#define Abs_Free(c) \
  do { if (c) { free((c)->instData); free(c); } } while(0);

#endif
