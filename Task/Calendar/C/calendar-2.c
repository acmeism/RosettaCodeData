#include <gadget/gadget.h>
LIB_GADGET_START

void draw_calendar( RDS(char*,calendario), int year );
void print_calendar( RDS(char*,calendario) );

Main

   Assert( Arg_count ==2, fail_arg );
   Get_arg_int( year, 1 );

   ACTUAL_LANG_DATE = EN; /* text in english */

   New array calendario as string;
   /* get full year:
      112 = code for months after initial month.
      1 = initial month
      year = well... */
   calendario = Calendar(calendario, 112, 1, year);

   draw_calendar( SDS(calendario), year );

   Free str array calendario;

   Exception( fail_arg ){
       Msg_yellow("Modo de uso:\n  ./calendar <nYear>");
   }

End

void draw_calendar( RDS( char*, calendario), int year )
{
   int fila=4, columna=1, cnt_columna=1, cnt_mes=0, i=0;

   Cls;
   At 2,35;  Print "%d", year;

   while ( cnt_mes < 12 )
   {
      String month_name;
      Stack {
          Store ( month_name, Pad_c( Capital( Get_monthname(cnt_mes++) ),' ',23) );
      } Stack_off;

      At fila, columna;  Print "%s", month_name;

      Atrow ++fila;

      Range for calendario [ i+1: 1: i+8, 0:1: Cols(calendario) ];
      print_calendar( SDS(calendario) );
      --fila;

      ++cnt_columna;
      columna += 25;
      When( cnt_columna == 4 ) {
          cnt_columna = columna = 1;
          fila+=9;
      }
      i+=8;
      Free secure month_name;
   }
   Prnl;
}


void print_calendar( RDS(char*,calendario) )
{
   int i,j;
   int row = SCREEN_ROW;

   Iterup( row, calendario, i)
   {
       Iterup( col, calendario, j)
       {
            Print "%*s", 3, $calendario[i,j];
       }
       Atrow ++row;
   }
}
