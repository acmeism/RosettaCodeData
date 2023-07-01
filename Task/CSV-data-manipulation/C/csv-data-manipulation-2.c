#include <gadget/gadget.h>

LIB_GADGET_START

void Muestra_archivo_original();

Main
   if(Exist_file("load_matrix.txt"))
   {
       /* recupero informacion del archivo para su apertura segura */
       F_STAT dataFile = Stat_file("load_matrix.txt");
       if(dataFile.is_matrix)   // tiene forma de matriz???
       {
            New multitype test;

            /* establezco los rangos a leer */
            Range for test [0:1:dataFile.total_lines-1, 0:1:dataFile.max_tokens_per_line-1];

            /* cargamos el array con detección de enteros como LONG */
            test = Load_matrix_mt( pSDS(test), "load_matrix.txt", dataFile, DET_LONG);

            /* modifica algunas cosas del archivo */
            /* sChg() no es necesario aquí, porque no se está cambiando el tipo
               de la celda, sino que se reemplaza el string: */
            ///sChg( test, 0,1, "Columna 1");

            /* Con Let() basta... */
            Let( $s-test[0,1], "Columna 1");
            $l-test[2,1] = 1000;
            $l-test[2,2] = 2000;

            /* inserto filas */
            /* preparo la fila a insertar */
            New multitype nueva_fila;
            sAppend_mt(nueva_fila,"fila 3.1");
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
            DEC_PREC = 20; /* establece precision decimal para despliegue */

            All range for test;
            Save_matrix_mt(SDS(test), "save_matrix.txt" );

            Free multitype test;

            Print "\nArchivo original:\n";
            Muestra_archivo_original();
       }
   }

End

void Muestra_archivo_original(){
    String csys;
    csys = `cat load_matrix.txt`;
    Print "\n%s\n", csys;
    Free secure csys;
}
