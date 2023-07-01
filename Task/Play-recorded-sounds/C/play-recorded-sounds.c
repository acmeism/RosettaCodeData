/*
plays the sound file, and returns a string with the PID number of that play.

Call:
   char* pid_sound = put_sound( "file.wav" );
 or
   String pid_sound;
   ....
   Fn_let( pid_sound, put_sound( "file.wav" ) );
*/
char * put_sound( char* file_sound )
{
   String PID_SOUND;
   system( file_sound );
   PID_SOUND = `pidof aplay`;
   char ot = Set_new_sep(' ');
   Fn_let( PID_SOUND, Get_token(PID_SOUND, 1));
   Set_token_sep(ot);
   return PID_SOUND;
}

/*
   Deletes a sound that is playing.
   It may happen that when trying to kill the process, "aplay" has already finished.
   Call:
      kill_sound( pid_sound );
      Free secure pid_sound;

*/
void kill_sound( char * PID_SOUND )
{
   String pid;
   pid = `pidof aplay`;
   if( Occurs( PID_SOUND, pid ){
       char strkill[256];
       sprintf( strkill, "kill -9 %s </dev/null >/dev/null 2>&1 &", PID_SOUND);
       system(strkill);
   }
   Free secure pid;
}

/*
   Clears all sounds that are playing.
   Call:
       kill_all_sounds();
   and then free all string of pid's:
       Free secure pid1, pid2, ... ;
*/
void kill_all_sounds()
{
   String PID;
   Fn_let ( PID, Get_sys("pidof aplay" ));
   if (strlen(PID)>0){
      char cpids[256];
      sprintf(cpids,"kill -9 %s </dev/null >/dev/null 2>&1",PID);
      system(cpids);
   }
   Free secure PID;
}
