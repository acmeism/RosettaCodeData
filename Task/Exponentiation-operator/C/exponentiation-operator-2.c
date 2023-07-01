#define generic_pow(base, exp)\
    _Generic((base),\
            double: dpow,\
            int: ipow)\
    (base, exp)

int main()
{
    printf("2^6 = %d\n", generic_pow(2,6));
    printf("2^-6 = %d\n", generic_pow(2,-6));
    printf("2.71^6 = %lf\n", generic_pow(2.71,6));
    printf("2.71^-6 = %lf\n", generic_pow(2.71,-6));
}
