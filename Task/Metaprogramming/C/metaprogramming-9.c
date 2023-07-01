#include <gadget/gadget.h>

LIB_GADGET_START

void Muestra_archivo_original();

Main
   Assert (Exist_file("load_matrix.txt"), file_not_found);

   /* recupero informacion del archivo para su apertura segura */
   F_STAT dataFile = Stat_file("load_matrix.txt");
   Assert (dataFile.is_matrix, file_not_matrixable)  // tiene forma de matriz???

   New multitype test;

   /* The data range to be read is established.
      It is possible to read only part of the file using these ranges. */
   Range for test [0:1:dataFile.total_lines-1, 0:1:dataFile.max_tokens_per_line-1];

   /* cargamos el array detectando números enteros como long */
   test = Load_matrix_mt( pSDS(test), "load_matrix.txt", dataFile, DET_LONG);

   /* modifica algunas cosas del archivo */
   Let( $s-test[0,1], "Columna 1");
   $l-test[2,1] = 1000;
   $l-test[2,2] = 2000;

   /* inserto filas */
   /* preparo la fila a insertar */
   New multitype nueva_fila;
   sAppend_mt(nueva_fila,"fila 3.1");  /* sAppend_mt() and Append_mt() are macros */
   Append_mt(nueva_fila,float,0.0);
   Append_mt(nueva_fila,int,0);
   Append_mt(nueva_fila,double,0.0);
   Append_mt(nueva_fila,long, 0L);

   /* insertamos la misma fila en el array, 3 veces */
   test = Insert_row_mt(pSDS(test),pSDS(nueva_fila), 4);
   test = Insert_row_mt(pSDS(test),pSDS(nueva_fila), 4);
   test = Insert_row_mt(pSDS(test),pSDS(nueva_fila), 4);
   Free multitype nueva_fila;

   Print "\nGuardando archivo en \"save_matrix.txt\"...\n";
   DEC_PREC = 20; /* establece precision decimal */

   All range for test;
   Save_matrix_mt(SDS(test), "save_matrix.txt" );

   Free multitype test;

   Print "\nArchivo original:\n";
   Muestra_archivo_original();

   Exception( file_not_found ){
      Msg_red("File not found\n");
   }
   Exception( file_not_matrixable ){
      Msg_red("File is not matrixable\n");
   }

End

void Muestra_archivo_original(){
    String csys;
    csys = `cat load_matrix.txt`;
    Print "\n%s\n", csys;
    Free secure csys;
}
