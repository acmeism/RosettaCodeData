#define  Str_init(_V_)       char * _V_=NULL;

#define  Free_secure(_X_)    if(_X_) { free(_X_); _X_=NULL; }

#define  Let(_X_,_Y_)       \
    do{\
       if(_X_) free(_X_);\
       int len = strlen(_Y_);\
       _X_ = (char*)calloc( len + 1, 1);\
       if(_X_) { memcpy(_X_, _Y_, len); }\
       else { perror("\033[38;5;196mLet: No hay memoria para <"#_X_">(CALLOC)\n\033[0m"); }\
    }while(0);

/* inicia el trabajo con el stack */
#define  Stack       if( (PILA_GADGET = 1) )

/* finaliza el trabajo con el stack. La pila debe quedar en "0" */
#define  Stack_off   \
      PILA_GADGET = 0; \
      if(CONTADOR_PILA>=0){ Msg_red("Proceso termina con stack ocupado: borro sobrante\n");\
      CONTADOR_PILA=-1; }

/*
   STORE almacena el valor en la variable indicada, obtenido desde el
   stack. */
#define Store(_X_,_Y_)   \
 do{\
   _Y_;\
   if(PILA_GADGET){\
       if( CONTADOR_PILA>=0 ){\
           Let(_X_, pila_de_trabajo[CONTADOR_PILA]);CONTADOR_PILA--;\
       }\
   }else{ Msg_amber("Store: No hay datos en la pila");}\
 }while(0);
...
#define Main  \
        int main(int argc, char* argv[]){\
            __TOKEN__=NULL;\
            Init_token();\
            Init_stack;

/* SALIDA NORMAL */
#define End              End_token(); \
                         Free_stack_str;\
                         return(0); }
