#include<limits.h>
#include<stdlib.h>
#include<stdio.h>

typedef struct{
    int sourceVertex, destVertex;
    int edgeWeight;
}edge;

typedef struct{
    int vertices, edges;
    edge* edgeMatrix;
}graph;

graph loadGraph(char* fileName){
    FILE* fp = fopen(fileName,"r");

    graph G;
    int i;

    fscanf(fp,"%d%d",&G.vertices,&G.edges);

    G.edgeMatrix = (edge*)malloc(G.edges*sizeof(edge));

    for(i=0;i<G.edges;i++)
        fscanf(fp,"%d%d%d",&G.edgeMatrix[i].sourceVertex,&G.edgeMatrix[i].destVertex,&G.edgeMatrix[i].edgeWeight);

    fclose(fp);

    return G;
}

void floydWarshall(graph g){
    int processWeights[g.vertices][g.vertices], processedVertices[g.vertices][g.vertices];
    int i,j,k;

    for(i=0;i<g.vertices;i++)
        for(j=0;j<g.vertices;j++){
            processWeights[i][j] = SHRT_MAX;
            processedVertices[i][j] = (i!=j)?j+1:0;
        }

    for(i=0;i<g.edges;i++)
        processWeights[g.edgeMatrix[i].sourceVertex-1][g.edgeMatrix[i].destVertex-1] = g.edgeMatrix[i].edgeWeight;

    for(i=0;i<g.vertices;i++)
        for(j=0;j<g.vertices;j++)
            for(k=0;k<g.vertices;k++){
                if(processWeights[j][i] + processWeights[i][k] < processWeights[j][k]){
                    processWeights[j][k] = processWeights[j][i] + processWeights[i][k];
                    processedVertices[j][k] = processedVertices[j][i];
                }
            }

    printf("pair    dist   path");
    for(i=0;i<g.vertices;i++)
        for(j=0;j<g.vertices;j++){
            if(i!=j){
                printf("\n%d -> %d %3d %5d",i+1,j+1,processWeights[i][j],i+1);
                k = i+1;
                do{
                    k = processedVertices[k-1][j];
                    printf("->%d",k);
                }while(k!=j+1);
            }
        }
}

int main(int argC,char* argV[]){
    if(argC!=2)
        printf("Usage : %s <file containing graph data>");
    else
        floydWarshall(loadGraph(argV[1]));
    return 0;
}
