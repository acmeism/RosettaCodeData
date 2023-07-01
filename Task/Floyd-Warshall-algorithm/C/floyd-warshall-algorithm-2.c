#include <limits.h>
#include <gadget/gadget.h>

LIB_GADGET_START

/* algunos datos globales */
int vertices,edges;

/* algunos prototipos */
F_STAT DatosdeArchivo( const char *cFile);
int * CargaMatriz(int * mat, DS_ARRAY * mat_data, const char * cFile, F_STAT stat );
int * CargaGrafo(int * graph, DS_ARRAY * graph_data, const char *cFile);
void Floyd_Warshall(int * graph, DS_ARRAY graph_data);

/* bloque principal */
Main
   if ( Arg_count != 2 ){
       Msg_yellow("Modo de uso:\n   ./floyd <archivo_de_vertices>\n");
       Stop(1);
   }
   Get_arg_str (cFile,1);
   Set_token_sep(' ');
   Cls;
   if(Exist_file(cFile)){
       New array graph as int;
       graph = CargaGrafo( pSDS(graph), cFile);
       if(graph){
           /* calcula Floyd-Warshall */
           Print "Vertices=%d, edges=%d\n",vertices,edges;

           Floyd_Warshall( SDS(graph) ); Prnl;

           Free array graph;
       }

   }else{
       Msg_redf("No existe el archivo %s",cFile);
   }
   Free secure cFile;
End

void Floyd_Warshall( RDS(int,graph) ){

    Array processedVertices as int(vertices,vertices);
    Fill array processWeights as int(vertices,vertices) with SHRT_MAX;

    int i,j,k;
    Range for processWeights [0:1:vertices, 0:1:vertices ];

    Compute_for( processWeights, i,j,
                     $processedVertices[i,j] = (i!=j)?j+1:0;
               )

#define    VERT_ORIG 0
#define    VERT_DEST 1
#define    WEIGHT    2

    Iterator up i [0:1:edges] {
             $2processWeights[ $graph[i,VERT_ORIG]-1, $graph[i,VERT_DEST]-1 ] = $graph[i,WEIGHT];
    }

    Compute_for (processWeights,i,j,
          Iterator up k [0:1:vertices] {
                if( $processWeights[j,i] + $processWeights[i,k] < $processWeights[j,k] )
                {
                    $processWeights[j,k] = $processWeights[j,i] + $processWeights[i,k];
                    $processedVertices[j,k] = $processedVertices[j,i];
                }
          } );

    Print "pair    dist   path";

    // ya existen rangos definios para "processWeights":
    Compute_for(processWeights, i, j,
                if(i!=j)
                {
                    Print "\n%d -> %d %3d %5d", i+1, j+1, $processWeights[i,j], i+1;
                    int k = i+1;
                    do{
                        k = $processedVertices[k-1,j];
                        Print " -> %d", k;
                    }while(k!=j+1);
                }
               );

    Free array processWeights, processedVertices;
}

F_STAT DatosdeArchivo( const char *cFile){
   return Stat_file(cFile);
}

int * CargaMatriz( pRDS(int, mat), const char * cFile, F_STAT stat ){
   return Load_matrix( SDS(mat), cFile, stat);
}

int * CargaGrafo( pRDS(int, graph), const char *cFile){

   F_STAT dataFile = DatosdeArchivo(cFile);
   if(dataFile.is_matrix){

       Range ptr graph [0:1:dataFile.total_lines-1, 0:1:dataFile.max_tokens_per_line-1];

       graph = CargaMatriz( SDS(graph), cFile, dataFile);

       if( graph ){
           /* obtengo vertices = 4 y edges = 5 */
           edges = dataFile.total_lines;

           Block( vertices, Range ptr graph [ 0:1:pRows(graph), 0:1:1 ];
                            DS_MAXMIN  maxNode = Max_array( SDS(graph) );
                            Out_int( $graph[maxNode.local] ) );
       }else{
           Msg_redf("Archivo \"%s\" no ha podido ser cargado",cFile);
       }

   }else{
       Msg_redf("Archivo \"%s\" no es cuadrado",cFile);
   }
   return graph;
}
