/* declara un array vacío */
#define New_mt_array(_X_)  \
    MT_CELL *_X_ = NULL;\
    Define_New_Array(_X_)\
    _X_##_data.type = MULTI_TYPE;
....
/* acceso a celdas string */
#define sCell(_X_,...) CONCAT2(Cell_mtstr, COUNT_ARGUMENTS(__VA_ARGS__))(_X_, ##__VA_ARGS__)

#define Cell_mtstr1(_X_,ARG1)              (_X_[ ARG1 ].value)
#define Cell_mtstr2(_X_,ARG1,ARG2)         (_X_[ ( ARG1 ) * ( _X_##_data.cols ) + ( ARG2 ) ].value)
#define Cell_mtstr3(_X_,ARG1,ARG2,ARG3)    (_X_[ ( ( ARG1 ) * ( _X_##_data.cols ) + ( ARG2 ) ) + \
                                           ( ARG3 ) * ( _X_##_data.cols * _X_##_data.rows ) ].value)
...
/* acceso a celdas long */
#define lCell(_X_,...) CONCAT2(Cell_mtlng, COUNT_ARGUMENTS(__VA_ARGS__))(_X_, ##__VA_ARGS__)

#define Cell_mtlng1(_X_,ARG1)              *((long *)(_X_[ ARG1 ].value))
#define Cell_mtlng2(_X_,ARG1,ARG2)         *((long *)(_X_[ ( ARG1 ) * ( _X_##_data.cols ) + ( ARG2 ) ].value))
#define Cell_mtlng3(_X_,ARG1,ARG2,ARG3)    *((long *)(_X_[ ( ( ARG1 ) * ( _X_##_data.cols ) + ( ARG2 ) ) + \
                                           ( ARG3 ) * ( _X_##_data.cols * _X_##_data.rows ) ].value))

...
/* RANGOS para acceso iterado */
#define Range_for(_X_, ...)  CONCAT2(Range_for, COUNT_ARGUMENTS(__VA_ARGS__))(_X_, ##__VA_ARGS__)

/* para un array 1D */
#define Range_for3(_X_,A1,A2,A3)  \
        _X_##_data.rowi=A1;_X_##_data.rowinc=A2;_X_##_data.rowe=A3;

/* para un array 2D */
#define Range_for6(_X_,A1,A2,A3,B1,B2,B3) \
        _X_##_data.rowi=A1;_X_##_data.rowinc=A2;_X_##_data.rowe=A3; \
        _X_##_data.coli=B1;_X_##_data.colinc=B2;_X_##_data.cole=B3;
....
