#include <gmpxx.h>

struct menu_entry {
    mpz_class amount;
    std::string name;
    mpf_class price;
};

int main() {
    menu_entry menu[] = { 4000000000000000, "hamburgers", 5.50,
                          2, "milkshakes", 2.86 };
    mpf_class taxRate;
    taxRate.set_str("0.0765", 10);
    mpf_class total = 0;
    for (menu_entry i : menu)
        total += i.price * i.amount;
    gmp_printf("total: €%.2Ff\n", total.get_mpf_t());
    mpf_class tax = total * taxRate;
    gmp_printf("tax: €%.2Ff\n", tax.get_mpf_t());
    gmp_printf("total+tax: €%.2Ff\n", mpf_class{total+tax}.get_mpf_t());
}
