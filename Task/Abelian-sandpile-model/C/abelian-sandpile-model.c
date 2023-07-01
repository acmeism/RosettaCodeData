#include<stdlib.h>
#include<string.h>
#include<stdio.h>

int main(int argc, char** argv)
{
	int i,j,sandPileEdge, centerPileHeight, processAgain = 1,top,down,left,right;	
	int** sandPile;
	char* fileName;
	static unsigned char colour[3];

	if(argc!=3){
		printf("Usage: %s <Sand pile side> <Center pile height>",argv[0]);
		return 0;
	}

	sandPileEdge = atoi(argv[1]);
	centerPileHeight = atoi(argv[2]);

	if(sandPileEdge<=0 || centerPileHeight<=0){
		printf("Sand pile and center pile dimensions must be positive integers.");
		return 0;
	}

	sandPile = (int**)malloc(sandPileEdge * sizeof(int*));

	for(i=0;i<sandPileEdge;i++){
		sandPile[i] = (int*)calloc(sandPileEdge,sizeof(int));
	}

	sandPile[sandPileEdge/2][sandPileEdge/2] = centerPileHeight;

	printf("Initial sand pile :\n\n");

	for(i=0;i<sandPileEdge;i++){
		for(j=0;j<sandPileEdge;j++){
			printf("%3d",sandPile[i][j]);
		}
		printf("\n");
	}

	while(processAgain == 1){

		processAgain = 0;
		top = 0;
		down = 0;
		left = 0;
		right = 0;

		for(i=0;i<sandPileEdge;i++){
			for(j=0;j<sandPileEdge;j++){
				if(sandPile[i][j]>=4){				
					if(i-1>=0){
						top = 1;
						sandPile[i-1][j]+=1;
						if(sandPile[i-1][j]>=4)
							processAgain = 1;
					}
					if(i+1<sandPileEdge){
						down = 1;
						sandPile[i+1][j]+=1;
						if(sandPile[i+1][j]>=4)
							processAgain = 1;
					}
					if(j-1>=0){
						left = 1;
						sandPile[i][j-1]+=1;
						if(sandPile[i][j-1]>=4)
							processAgain = 1;
					}
					if(j+1<sandPileEdge){
						right = 1;
						sandPile[i][j+1]+=1;
						if(sandPile[i][j+1]>=4)
							processAgain = 1;
					}
				sandPile[i][j] -= (top + down + left + right);
				if(sandPile[i][j]>=4)
					processAgain = 1;
				}
			}
		}
	}

	printf("Final sand pile : \n\n");

	for(i=0;i<sandPileEdge;i++){
		for(j=0;j<sandPileEdge;j++){
			printf("%3d",sandPile[i][j]);
		}
		printf("\n");
	}

	fileName = (char*)malloc((strlen(argv[1]) + strlen(argv[2]) + 23)*sizeof(char));

	strcpy(fileName,"Final_Sand_Pile_");
	strcat(fileName,argv[1]);
	strcat(fileName,"_");
	strcat(fileName,argv[2]);
	strcat(fileName,".ppm");
	
	FILE *fp = fopen(fileName,"wb");

	fprintf(fp,"P6\n%d %d\n255\n",sandPileEdge,sandPileEdge);

	for(i=0;i<sandPileEdge;i++){
		for(j=0;j<sandPileEdge;j++){
			colour[0] = (sandPile[i][j] + i)%256;
			colour[1] = (sandPile[i][j] + j)%256;
			colour[2] = (sandPile[i][j] + i*j)%256;
			fwrite(colour,1,3,fp);
		}
	}
	
	fclose(fp);

	printf("\nImage file written to %s\n",fileName);

	return 0;
}
