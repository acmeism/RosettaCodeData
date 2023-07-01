#include <gadget/gadget.h>

LIB_GADGET_START

/* prototypes */
GD_VIDEO put_chemical_cell( GD_VIDEO table, MT_CELL * E, DS_ARRAY E_data );
MT_CELL* load_chem_elements( MT_CELL * E, DS_ARRAY * E_data );
int select_box_chemical_elem( RDS(MT_CELL, Elements) );
void put_information(RDS( MT_CELL, elem), int i);

Main

   GD_VIDEO table;
   /* las dimensiones del terminal son muy importantes
      para desplegar la tabla */
   Resize_terminal(42,135);
   Init_video( &table );

   Gpm_Connect conn;

   if ( ! Init_mouse(&conn)){
        Msg_red("No se puede conectar al servidor del ratón\n");
        Stop(1);
   }
   Enable_raw_mode();
   Hide_cursor;

   /* I declare a multitype array "Elements", and load the file that will populate this array. */
   New multitype Elements;
   Elements = load_chem_elements( pSDS(Elements) );
   Throw( load_fail );

  /* I create a "Button" object with which the execution will end. */
   New objects Btn_exit;
   Btn_exit = New_object_mouse( SMD(&Btn_exit), BUTTOM, "  Terminar  ", 6,44, 15, 0);

  /* Fill the space on the screen with the table of chemical elements. */
   table = put_chemical_cell( table, SDS(Elements) );

  /* I print the screen and place the mouse object. */
   Refresh(table);
   Put object Btn_exit;

  /* I wait for a mouse event. */
   int c;
   Waiting_some_clic(c)
   {
       if( select_box_chemical_elem(SDS(Elements)) ){
           Waiting_some_clic(c) break;
       }
       if (Object_mouse( Btn_exit)) break;

       Refresh(table);
       Put object Btn_exit;
   }

   Free object Btn_exit;
   Free multitype Elements;

   Exception( load_fail ){
      Msg_red("No es un archivo matriciable");
   }

   Free video table;
   Disable_raw_mode();
   Close_mouse();
   Show_cursor;

   At SIZE_TERM_ROWS,0;
   Prnl;
End

void put_information(RDS(MT_CELL, elem), int i)
{
    At 2,19;
    Box_solid(11,64,67,17);
    Color(15,17);
    At 4,22; Print "Elemento (%s) = %s", (char*)$s-elem[i,5],(char*)$s-elem[i,6];
    if (Cell_type(elem,i,7) == double_TYPE ){
        At 5,22; Print "Peso atómico  = %f", $d-elem[i,7];
    }else{
        At 5,22; Print "Peso atómico  = (%ld)", $l-elem[i,7];
    }
    At 6,22; Print "Posición      = (%ld, %ld)",$l-elem[i,0]+ ($l-elem[i,0]>=8 ? 0:1),$l-elem[i,1]+1;
    At 8,22; Print "1ª energía de";
    if (Cell_type(elem,i,12) == double_TYPE ){
        At 9,22; Print "ionización (kJ/mol) = %.*f",2,$d-elem[i,12];
    }else{
        At 9,22; Print "ionización (kJ/mol) = ---";
    }
    if (Cell_type(elem,i,13) == double_TYPE ){
        At 10,22; Print "Electronegatividad  = %.*f",2,$d-elem[i,13];
    }else{
        At 10,22; Print "Electronegatividad  = ---";
    }
    At 4,56; Print "Conf. electrónica:";
    At 5,56; Print "       %s", (char*)$s-elem[i,14];
    At 7,56; Print "Estados de oxidación:";
    if ( Cell_type(elem,i,15) == string_TYPE ){
        At 8,56; Print "       %s", (char*)$s-elem[i,15];
    }else{
       /* Strangely, when the file loader detects a "+n", it treats it as a string,
          but when it detects a "-n", it treats it as a "long".
          I must review that. */
        At 8,56; Print "       %ld", $l-elem[i,15];
    }
    At 10,56; Print "Número Atómico: %ld",$l-elem[i,4];
    Reset_color;
}

int select_box_chemical_elem( RDS(MT_CELL, elem) )
{
   int i;
   Iterator up i [0:1:Rows(elem)]{
       if ( Is_range_box( $l-elem[i,8], $l-elem[i,9], $l-elem[i,10], $l-elem[i,11]) ){
           Gotoxy( $l-elem[i,8], $l-elem[i,9] );
           Color_fore( 15 ); Color_back( 0 );
           Box( 4,5, DOUB_ALL );

           Gotoxy( $l-elem[i,8]+1, $l-elem[i,9]+2); Print "%ld",$l-elem[i,4];
           Gotoxy( $l-elem[i,8]+2, $l-elem[i,9]+2); Print "%s",(char*)$s-elem[i,5];
           Flush_out;
           Reset_color;
           put_information(SDS(elem),i);
           return 1;
       }
   }
   return 0;
}

GD_VIDEO put_chemical_cell(GD_VIDEO table, MT_CELL * elem, DS_ARRAY elem_data)
{
   int i;

   /* put each cell */
   Iterator up i [0:1:Rows(elem)]{
       long rx = 2+($l-elem[i,0]*4);
       long cx = 3+($l-elem[i,1]*7);
       long offr = rx+3;
       long offc = cx+6;

       Gotoxy(table, rx, cx);

       Color_fore(table, $l-elem[i,2]);
       Color_back(table,$l-elem[i,3]);

       Box(table, 4,5, SING_ALL );

       char Atnum[50], Elem[50];
       sprintf(Atnum,"\x1b[3m%ld\x1b[23m",$l-elem[i,4]);
       sprintf(Elem, "\x1b[1m%s\x1b[22m",(char*)$s-elem[i,5]);

       Outvid(table,rx+1, cx+2, Atnum);
       Outvid(table,rx+2, cx+2, Elem);

       Reset_text(table);
       /* Update positions of each cell to be detected by the mouse. */
       $l-elem[i,8] = rx;
       $l-elem[i,9] = cx;
       $l-elem[i,10] = offr;
       $l-elem[i,11] = offc;

   }
   /* put rows and cols */
   Iterator up i [ 1: 1: 19 ]{
       Gotoxy(table, 31, 5+(i-1)*7);
       char num[5]; sprintf( num, "%d",i );
       Outvid(table, num );
   }
   Iterator up i [ 1: 1: 8 ]{
       Gotoxy(table, 3+(i-1)*4, 130);
       char num[5]; sprintf( num, "%d",i );
       Outvid(table, num );
   }
   Outvid( table, 35,116, "8");
   Outvid( table, 39,116, "9");

   /* others */
   Color_fore(table, 15);
   Color_back(table, 0);
   Outvid(table,35,2,"Lantánidos ->");
   Outvid(table,39,2,"Actínidos  ->");
   Reset_text(table);
   return table;
}

MT_CELL* load_chem_elements( MT_CELL * E, DS_ARRAY * E_data )
{
   F_STAT dataFile = Stat_file("chem_table.txt");
   if( dataFile.is_matrix ){
       /*
          Set the ranges to read from the file.
          You can choose the portion of the file that you want to upload.
       */
       Range ptr E [0:1:dataFile.total_lines-1, 0:1:dataFile.max_tokens_per_line-1];
       E = Load_matrix_mt( SDS(E), "chem_table.txt", dataFile, DET_LONG);
   }else{
       Is_ok=0;
   }
   return E;
}
