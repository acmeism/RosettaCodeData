#include<stdlib.h>
#include<stdio.h>

long totient(long n){
	long tot = n,i;
	
	for(i=2;i*i<=n;i+=2){
		if(n%i==0){
			while(n%i==0)
				n/=i;
			tot-=tot/i;
		}
		
		if(i==2)
			i=1;
	}
	
	if(n>1)
		tot-=tot/n;
	
	return tot;
}

long* perfectTotients(long n){
	long *ptList = (long*)malloc(n*sizeof(long)), m,count=0,sum,tot;
	
	for(m=1;count<n;m++){
		 tot = m;
		 sum = 0;
        while(tot != 1){
            tot = totient(tot);
            sum += tot;
        }
        if(sum == m)
			ptList[count++] = m;
        }
		
		return ptList;
}

long main(long argC, char* argV[])
{
	long *ptList,i,n;
	
	if(argC!=2)
		printf("Usage : %s <number of perfect Totient numbers required>",argV[0]);
	else{
		n = atoi(argV[1]);
		
		ptList = perfectTotients(n);
		
		printf("The first %d perfect Totient numbers are : \n[",n);
		
		for(i=0;i<n;i++)
			printf(" %d,",ptList[i]);
		printf("\b]");
	}
	
	return 0;
}
