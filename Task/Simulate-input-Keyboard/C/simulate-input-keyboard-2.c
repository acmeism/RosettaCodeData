#include <gadget/gadget.h>

LIB_GADGET_START

Main
   Enable_raw_mode();
   int tecla=0;
   int t=0;
   while (tecla!=27 ){
       while ( Kbhit() ){
           tecla = Getch();
           Disable_raw_mode();
          /* para algunas teclas, imprimirá el código interno que maneja
             Gadget para estos eventos, código que no es estándar */
           printf("TECLA = %d\n",tecla);
           Enable_raw_mode();
       }
       usleep(100);
       ++t;
       if ( t==10000 ){
           system("xdotool key Return");
       }else if( t==11000 ){
          // Mi teclado actual es del MacBook Pro.
          // En otro tipo de teclado, el código puede cambiar.
          // consulte X11/keysymdef.h para más informacion.
           Key_put(KEYP_ENTER); //0xff8d);

       }else if( t==12000 ){
           Key_put(KEYP_LEFT);

       }else if( t==13000 ){
           Key_put(KEYP_RIGHT);

       }else if( t==14000 ){
           Key_put(KEYP_UP);
       }else if( t==15000 ){
           Key_put(KEYP_DOWN);

       }else if( t==16000 ){
           Key_put(KEYP_PAGEUP);
       }else if( t==17000 ){
           Key_put(KEYP_PAGEDOWN);

       }else if( t==18000 ){
           Key_put(KEYP_HOME);
       }else if( t==19000 ){
           Key_put(KEYP_END);
       }else if( t==20000 ){
           Key_put(' ');
       }else if( t==21000 ){
           Key_put(KEYP_BACKSP);
       }else if( t==22000 ){
           Key_put(KEYP_TAB);
       }else if( t==23000 ){
           Key_put(KEYP_DELETE);

       }else if( t==24000 ){
           Key_put_ctrl('a');
       }else if( t==24100 ){
           Key_put_ctrl('b');
       }else if( t==24200 ){
           Key_put_ctrl('w');

       }else if( t==24300 ){
           Key_put_shift('a');

       }else if( t==24400 ){
           Key_put_alt('j'); // esto no funciona en mi teclado

       }else if( t>=25000 ){
           Key_put(KEYP_ESCAPE);
       }
   }

  // Put_kbd_text() reconoce estos caracteres: otros caracteres, el
  // resultado puede ser indefinido.

   Put_kbd_text("Hola mundo[](){},.:;-_=?$%&/#@! \t<cruel>\n Año 2023");

   String read;
   // si no se ha puesto nada en el buffer de entrada con Put_kbd_text(),
   // read será NULL:
   read = Read_typed_string();

   Disable_raw_mode();
   if ( read){
       printf("\nTEXTO = %s\nChar = %d\n",read, read[strlen(read)-1]);
   }
   free(read);
End
