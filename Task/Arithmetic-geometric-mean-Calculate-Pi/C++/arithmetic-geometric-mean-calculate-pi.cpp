#include <gmpxx.h>

void agm(mpf_class& rop1, mpf_class& rop2, const mpf_class& op1,
        const mpf_class& op2)
{
    rop1 = (op1 + op2) / 2;
    rop2 = op1 * op2;
    mpf_sqrt(rop2.get_mpf_t(), rop2.get_mpf_t());
}

int main(void)
{
    mpf_set_default_prec(300000);
    mpf_class x0, y0, resA, resB, Z;

    x0 = 1;
    y0 = 0.5;
    Z  = 0.25;
    mpf_sqrt(y0.get_mpf_t(), y0.get_mpf_t());

    int n = 1;
    for (int i = 0; i < 8; i++) {
        agm(resA, resB, x0, y0);
        Z -= n * (resA - x0) * (resA - x0);
        n *= 2;

        agm(x0, y0, resA, resB);
        Z -= n * (x0 - resA) * (x0 - resA);
        n *= 2;
    }

    x0 = x0 * x0 / Z;
    gmp_printf ("%.100000Ff\n", x0.get_mpf_t());
    return 0;
}
