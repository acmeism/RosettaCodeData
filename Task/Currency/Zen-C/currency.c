//> link: -lgmp

import "gmp.h"

fn main() {
    let hamburgers: mpf_t;
    let milkshakes: mpf_t;
    let price1: mpf_t;
    let price2: mpf_t;
    let tax_pc: mpf_t;
    let total_pre_tax: mpf_t;
    let total_tax: mpf_t;
    let total_after_tax: mpf_t;
    let temp: mpf_t;

    mpf_init_set_ui(hamburgers, (c_ulong)4000000000000000);
    mpf_init_set_ui(milkshakes, (c_ulong)2);
    mpf_init_set_str(price1, "5.5", 10);
    mpf_init_set_str(price2, "2.86", 10);
    mpf_init_set_str(tax_pc, "0.0765", 10);
    mpf_inits(total_pre_tax, total_tax, total_after_tax, temp, NULL);

    mpf_mul(total_pre_tax, hamburgers, price1);
    mpf_mul(temp, milkshakes, price2);
    mpf_add(total_pre_tax, total_pre_tax, temp);
    mpf_mul(total_tax, total_pre_tax, tax_pc);
    mpf_add(total_after_tax, total_pre_tax, total_tax);
    gmp_printf("Total price before tax : $ %20.2Ff\n", total_pre_tax);
	gmp_printf("Total tax              : $ %20.2Ff\n", total_tax);
    gmp_printf("Total price after tax  : $ %20.2Ff\n", total_after_tax);
    mpf_clears(hamburgers, milkshakes, price1, price2, tax_pc,
               total_pre_tax, total_tax, total_after_tax, temp, NULL);
}
