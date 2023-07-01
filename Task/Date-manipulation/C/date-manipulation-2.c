#include <gadget/gadget.h>

LIB_GADGET_START

void write_human_date( const char* date, const char * time )
{
    Print "%s %d %d %d:%d%s EST\n", Get_monthname( Get_month( date )-1 ),\
                                    Get_day( date ), Get_year( date ), \
                                    Get_hour(time),Get_minute(time), \
                                    Get_hour(time)>12 ? "pm" : "am" ;
}

#define Sign(_N_)  ( (_N_)<0? -1 : 1 )

Main
   Assert( Arg_count==2, fail_input );
   Get_arg_int( addhour, 1 );

   Set_date_lang( EN );  // fix english language

   char * date = Get_date();
   char * time = Get_time();
   addhour = Sign( addhour )*addhour;

   write_human_date(date, time);

   int adddays = ( Time2sec(time) + addhour*60*60 ) / 86400;
   Get_fn_let( time, Sec2time( (Time2sec(time) + addhour*60*60 )) );
   Get_fn_let( date, Date_add( date, adddays ) );

   write_human_date(date, time);

   Free secure date, time;

  Exception( fail_input ){
     Msg_red("Use:\n   addhour <nHours>\n")
  }

End
