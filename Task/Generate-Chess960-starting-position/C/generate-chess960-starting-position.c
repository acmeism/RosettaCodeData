#include<stdlib.h>
#include<locale.h>
#include<wchar.h>
#include<stdio.h>
#include<time.h>

char rank[9];

int pos[8];

void swap(int i,int j){
	int temp = pos[i];
	pos[i] = pos[j];
	pos[j] = temp;
}

void generateFirstRank(){
	 int kPos,qPos,bPos1,bPos2,rPos1,rPos2,nPos1,nPos2,i;
	
	 for(i=0;i<8;i++){
		 rank[i] = 'e';
		 pos[i] = i;
	 }
		
	 do{
		 kPos = rand()%8;
		 rPos1 = rand()%8;
		 rPos2 = rand()%8;
	 }while((rPos1-kPos<=0 && rPos2-kPos<=0)||(rPos1-kPos>=0 && rPos2-kPos>=0)||(rPos1==rPos2 || kPos==rPos1 || kPos==rPos2));

	 rank[pos[rPos1]] = 'R';
	 rank[pos[kPos]] = 'K';
	 rank[pos[rPos2]] = 'R';
	
	 swap(rPos1,7);
	 swap(rPos2,6);
	 swap(kPos,5);
	
	 do{
		 bPos1 = rand()%5;
		 bPos2 = rand()%5;
	 }while(((pos[bPos1]-pos[bPos2])%2==0)||(bPos1==bPos2));

	 rank[pos[bPos1]] = 'B';
	 rank[pos[bPos2]] = 'B';
	
	 swap(bPos1,4);
	 swap(bPos2,3);
	
	 do{
		 qPos = rand()%3;
		 nPos1 = rand()%3;
	 }while(qPos==nPos1);
	
	 rank[pos[qPos]] = 'Q';
	 rank[pos[nPos1]] = 'N';
	
	 for(i=0;i<8;i++)
		 if(rank[i]=='e'){
			 rank[i] = 'N';
			 break;
		 }		
}

void printRank(){
	int i;
	
	#ifdef _WIN32
		printf("%s\n",rank);
	#else
	{
		setlocale(LC_ALL,"");
		printf("\n");
		for(i=0;i<8;i++){
			if(rank[i]=='K')
				printf("%lc",(wint_t)9812);
			else if(rank[i]=='Q')
				printf("%lc",(wint_t)9813);
			else if(rank[i]=='R')
				printf("%lc",(wint_t)9814);
			else if(rank[i]=='B')
				printf("%lc",(wint_t)9815);
			if(rank[i]=='N')
				printf("%lc",(wint_t)9816);
		}
	}
	#endif
}

int main()
{
	int i;
	
	srand((unsigned)time(NULL));
	
	for(i=0;i<9;i++){
		generateFirstRank();
		printRank();
	}
	
	return 0;
}
