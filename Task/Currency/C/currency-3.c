#include<stdio.h>
#include<gmp.h>

int main()
{
	mpf_t burgerUnitPrice, milkshakePrice, burgerTotalPrice, totalPrice, tax, burgerNum, milkshakeNum;
	
	mpf_inits(burgerUnitPrice, milkshakePrice, burgerTotalPrice, totalPrice, tax,burgerNum, milkshakeNum,NULL);
	
	mpf_set_d(burgerUnitPrice,5.50);
	mpf_set_d(milkshakePrice,2 * 2.86);
	mpf_set_d(burgerNum,4000000000000000);
	mpf_set_d(milkshakeNum,2);
	
	mpf_mul(burgerTotalPrice,burgerNum,burgerUnitPrice);
	mpf_add(totalPrice,burgerTotalPrice,milkshakePrice);
	
	mpf_set_str(tax,"0.0765",10);
	mpf_mul(tax,totalPrice,tax);
	
	gmp_printf("\nTotal price before tax : $ %.*Ff", 2, totalPrice);
	gmp_printf("\nTotal tax : $ %.*Ff", 2, tax);
	
	mpf_add(totalPrice,totalPrice,tax);
	
	gmp_printf("\nTotal price after tax : $ %.*Ff", 2, totalPrice);
	
	return 0;
}
