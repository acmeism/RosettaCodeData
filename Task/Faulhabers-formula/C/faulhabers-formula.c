#include <gmp.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
typedef unsigned long ul;
#define mpq_for(buf, op, n)\
do {\
        size_t i;\
        for (i = 0; i < (n); ++i)\
        mpq_##op(buf[i]);\
} while (0)

void mpz_choose_ui(mpz_t rop,ul a,ul b){
    mpz_set_ui(rop,1);
    for(ul i=0;i<b;i++){
        mpz_mul_ui(rop,rop,a-i);
    }
    for(ul i=1;i<=b;i++){
        mpz_div_ui(rop,rop,i);
    }
}
void bernoulli(mpq_t rop, unsigned int n){
    unsigned int m, j;
    mpq_t *a = malloc(sizeof(mpq_t) * (n + 1));
    mpq_for(a, init, n + 1);

    for (m = 0; m <= n; ++m) {
        mpq_set_ui(a[m], 1, m + 1);
        for (j = m; j > 0; --j) {
            mpq_sub(a[j-1], a[j], a[j-1]);
            mpq_set_ui(rop, j, 1);
            mpq_mul(a[j-1], a[j-1], rop);
        }
    }

    mpq_set(rop, a[0]);
    mpq_for(a, clear, n + 1);
    free(a);
}
void bernoullip(mpq_t rop,unsigned int n){
    bernoulli(rop,n);
    if(n!=1){return;}
    mpq_neg(rop,rop);
    return;
}

void mpq_print(mpq_t rop){
    mpz_t n,d;
    mpz_inits(n,d,NULL);
    mpq_get_num(n, rop);
    mpq_get_den(d, rop);
    gmp_printf("%Zd/%Zd\n", n, d);
    mpz_clears(n,d,NULL);
}
void mpz_print(mpz_t rop){

    gmp_printf("%Zd\n",rop);
}
void mpq_div_ui(mpq_t op1,mpq_t op2,ul op3){
    mpq_t tmp;
    mpq_init(tmp);
    mpq_set_ui(tmp,op3,1);
    mpq_div(op1,op2,tmp);
    mpq_clear(tmp);
}

void mpq_mul_z(mpq_t op1,mpq_t op2,mpz_t op3){
    mpq_t tmp;
    mpq_init(tmp);
    mpq_set_z(tmp,op3);
    mpq_mul(op1,op2,tmp);
    mpq_clear(tmp);
}
void mpq_to_mpz(mpz_t rop,mpq_t op){
    mpz_t tmp;
    mpz_init(tmp);
    mpq_get_num(rop,op);
    mpq_get_den(tmp,op);
    if(mpz_cmp_ui(tmp,1)!=0){
        mpz_div(rop,rop,tmp);
    }
    mpz_clear(tmp);
}
void faulhaber(mpq_t out,ul n,ul p){
    mpq_t tmp;
    mpz_t tmp2,tmp3;
    mpq_init(tmp);
    mpz_inits(tmp2,tmp3,NULL);
    mpq_clear(out);
    mpq_init(out);
    for(ul r=0;r<p+1;r++){
        bernoullip(tmp,r);
        mpz_choose_ui(tmp3,p+1,r);
        mpq_mul_z(tmp,tmp,tmp3);//mult by choose
        mpz_ui_pow_ui(tmp2,n,p+1-r);
        mpq_mul_z(tmp,tmp,tmp2);//that n thing
        mpq_add(out,out,tmp);
    }
    mpq_div_ui(out,out,p+1);
    mpz_t zout;
    mpz_init(zout);
    mpq_to_mpz(zout,out);
    mpz_print(zout);
    mpz_clear(zout);
    mpz_clears(tmp2,tmp3,NULL);
    mpq_clear(tmp);
}
int main(void)
{
    mpq_t rop;
    mpq_init(rop);
    for(int p=0;p<=5;p++){
        printf("sum of p%d\n",p);
        for (int i = 0; i <= 5;i++) {
            faulhaber(rop,i,p);
            //mpq_print(rop);
        }
    }
    mpq_clear(rop);
    return 0;
}
