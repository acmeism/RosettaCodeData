#include<stdio.h>
#include<gmp.h>

void firstCase(){
	mpf_t a,b,c;
	
	mpf_inits(a,b,c,NULL);
	
	mpf_set_str(a,"0.1",10);
	mpf_set_str(b,"0.2",10);
	mpf_add(c,a,b);
	
	gmp_printf("\n0.1 + 0.2 = %.*Ff",20,c);
}

void pathologicalSeries(){
	int n;
	mpf_t v1, v2, vn, a1, a2, a3, t2, t3, prod;
	
	mpf_inits(v1,v2,vn, a1, a2, a3, t2, t3, prod,NULL);
	
	mpf_set_str(v1,"2",10);
	mpf_set_str(v2,"-4",10);
	mpf_set_str(a1,"111",10);
	mpf_set_str(a2,"1130",10);
	mpf_set_str(a3,"3000",10);
	
	for(n=3;n<=100;n++){
		mpf_div(t2,a2,v2);
		mpf_mul(prod,v1,v2);
		mpf_div(t3,a3,prod);
		mpf_add(vn,a1,t3);
		mpf_sub(vn,vn,t2);
		
		if((n>=3&&n<=8) || n==20 || n==30 || n==50 || n==100){
			gmp_printf("\nv_%d : %.*Ff",n,(n==3)?1:(n>=4&&n<=7)?6:(n==8)?7:(n==20)?16:(n==30)?24:(n==50)?40:78,vn);
		}
		
		mpf_set(v1,v2);
		mpf_set(v2,vn);
	}
}

void healthySeries(){
	int n;
	
	mpf_t num,denom,result;
	mpq_t v1, v2, vn, a1, a2, a3, t2, t3, prod;
	
	mpf_inits(num,denom,result,NULL);
	mpq_inits(v1,v2,vn, a1, a2, a3, t2, t3, prod,NULL);
	
	mpq_set_str(v1,"2",10);
	mpq_set_str(v2,"-4",10);
	mpq_set_str(a1,"111",10);
	mpq_set_str(a2,"1130",10);
	mpq_set_str(a3,"3000",10);
	
	for(n=3;n<=100;n++){
		mpq_div(t2,a2,v2);
		mpq_mul(prod,v1,v2);
		mpq_div(t3,a3,prod);
		mpq_add(vn,a1,t3);
		mpq_sub(vn,vn,t2);
		
		if((n>=3&&n<=8) || n==20 || n==30 || n==50 || n==100){
			mpf_set_z(num,mpq_numref(vn));
			mpf_set_z(denom,mpq_denref(vn));
			mpf_div(result,num,denom);

			gmp_printf("\nv_%d : %.*Ff",n,(n==3)?1:(n>=4&&n<=7)?6:(n==8)?7:(n==20)?16:(n==30)?24:(n==50)?40:78,result);
		}
		
		mpq_set(v1,v2);
		mpq_set(v2,vn);
	}
}

int main()
{	
	mpz_t rangeProd;
	
	firstCase();
	
	printf("\n\nPathological Series : ");
	
	pathologicalSeries();
	
	printf("\n\nNow a bit healthier : ");
	
	healthySeries();

	return 0;
}
