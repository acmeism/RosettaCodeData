typedef unsigned int histogram_t;
typedef histogram_t *histogram;

#define GET_LUM(IMG, X, Y) ( (IMG)->buf[ (Y) * (IMG)->width + (X)][0] )

histogram get_histogram(grayimage im);
luminance histogram_median(histogram h);
