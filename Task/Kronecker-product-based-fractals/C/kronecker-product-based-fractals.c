#include<graphics.h>
#include<stdlib.h>
#include<stdio.h>

typedef struct{
    int row, col;
}cell;

int ROW,COL,SUM=0;

unsigned long raiseTo(int base,int power){
    if(power==0)
        return 1;
    else
        return base*raiseTo(base,power-1);
}

cell* kroneckerProduct(char* inputFile,int power){
    FILE* fp = fopen(inputFile,"r");

    int i,j,k,l;
    unsigned long prod;
    int** matrix;
    cell *coreList,*tempList,*resultList;

    fscanf(fp,"%d%d",&ROW,&COL);

    matrix = (int**)malloc(ROW*sizeof(int*));

    for(i=0;i<ROW;i++){
        matrix[i] = (int*)malloc(COL*sizeof(int));
        for(j=0;j<COL;j++){
            fscanf(fp,"%d",&matrix[i][j]);
            if(matrix[i][j]==1)
                SUM++;
        }
    }

    coreList = (cell*)malloc(SUM*sizeof(cell));
    resultList = (cell*)malloc(SUM*sizeof(cell));

    k = 0;

    for(i=0;i<ROW;i++){
        for(j=0;j<COL;j++){
            if(matrix[i][j]==1){
                coreList[k].row = i+1;
                coreList[k].col = j+1;
                resultList[k].row = i+1;
                resultList[k].col = j+1;
                k++;
            }
        }
    }

    prod = k;

    for(i=2;i<=power;i++){
        tempList = (cell*)malloc(prod*k*sizeof(cell));

        l = 0;

        for(j=0;j<prod;j++){
            for(k=0;k<SUM;k++){
                tempList[l].row = (resultList[j].row-1)*ROW + coreList[k].row;
                tempList[l].col = (resultList[j].col-1)*COL + coreList[k].col;
                l++;
            }
        }

        free(resultList);

        prod *= k;

        resultList = (cell*)malloc(prod*sizeof(cell));

        for(j=0;j<prod;j++){
            resultList[j].row = tempList[j].row;
            resultList[j].col = tempList[j].col;
        }
        free(tempList);
    }

    return resultList;
}

int main(){
    char fileName[100];
    int power,i,length;

    cell* resultList;

    printf("Enter input file name : ");
    scanf("%s",fileName);

    printf("Enter power : ");
    scanf("%d",&power);

    resultList = kroneckerProduct(fileName,power);

    initwindow(raiseTo(ROW,power),raiseTo(COL,power),"Kronecker Product Fractal");

    length = raiseTo(SUM,power);

    for(i=0;i<length;i++){
        putpixel(resultList[i].row,resultList[i].col,15);
    }

    getch();

    closegraph();

    return 0;
}
