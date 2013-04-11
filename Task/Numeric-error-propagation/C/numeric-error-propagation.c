#include <stdio.h>
#include <math.h>

struct imprecise {
    double value;
    double delta;
};

#define SQR(x) ((x) * (x))
struct imprecise imprecise_add(struct imprecise a, struct imprecise b)
{
    struct imprecise ret;
    ret.value = a.value + b.value;
    ret.delta = sqrt(SQR(a.delta) + SQR(b.delta));
    return ret;
}

struct imprecise imprecise_mul(struct imprecise a, struct imprecise b)
{
    struct imprecise ret;
    ret.value = a.value * b.value;
    ret.delta = sqrt(SQR(a.value * b.delta) + SQR(b.value * a.delta));
    return ret;
}

struct imprecise imprecise_div(struct imprecise a, struct imprecise b)
{
    struct imprecise ret;
    ret.value = a.value / b.value;
    ret.delta = sqrt(SQR(a.value * b.delta) + SQR(b.value * a.delta)) / SQR(b.value);
    return ret;
}

struct imprecise imprecise_pow(struct imprecise a, double c)
{
    struct imprecise ret;
    ret.value = pow(a.value, c);
    ret.delta = fabs(ret.value * c * a.delta / a.value);
    return ret;
}

int main(void) {
    struct imprecise x1 = {100, 1.1};
    struct imprecise y1 = {50, 1.2};
    struct imprecise x2 = {-200, 2.2};
    struct imprecise y2 = {-100, 2.3};
    struct imprecise d;

    d = imprecise_pow(imprecise_add(imprecise_pow(imprecise_add(x1, x2), 2),imprecise_pow(imprecise_add(y1, y2), 2)), 0.5);
    printf("d = %f \\pm %f\n", d.value, d.delta);
    return 0;
}
