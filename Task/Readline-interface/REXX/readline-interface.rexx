/*REXX program  implements  a  simple  "readline"  shell   (modeled after a DOS shell). */
trace off                                        /*suppress echoing of non-zero retCodes*/
signal on syntax;  signal on noValue             /*handle REXX program errors.          */
cmdX='ATTRIB CAL CHDIR COPY DEL DIR ECHO EDIT FC FIND KEDIT LLL MEM MKDIR MORE REM REXX',
                   'RMDIR SET TYPE VER XCOPY'    /* ◄──── the legal/known commands.     */
cls= 'CLS'                                       /*define the program to clear screen.  */
@hist.= '*** command not defined. ***'           /*initialize the history database.     */
hist#=0                                          /*the number of commands in the history*/
prompt='Enter command   ──or──  ?  ──or──  Quit' /*the default  PROMPT  message text.   */
sw=linesize()                                    /*some REXX don't have this BIF.       */
cls                                              /*start with a clean slate (terminal). */
redoing=0                                        /*flag for executing naked  ReDO  cmd. */
                                                 /* [↓]  do it 'til the fat lady sings. */
  do forever;    if prompter()  then iterate     /*Nothing entered?  Then go try again. */
       select                                    /* [↓]  now then, let's rock n' roll.  */
       when wordpos(xxxF,cmdX)\==0      then call .cmdX
       when xxxF=='EXIT' | xxxF="QUIT"  then leave         /*da fat lady is done singing*/
       when xxxF=='HISTORY'             then call .history
       when xxxF=='HELP'                then call .help
       when xxxF=='PROMPT'              then call .prompt
       when xxxF=='REDO'                then call .redo
       otherwise                             call er 'unknown command:'  xxx  yyy
       end   /*select*/
  end        /*forever*/

say xxxF'ting···'                                /*say goodbye, 'cause it's polite to do*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
er:      say;   say;   say '****error****';   say;   say arg(1);   say;   say;     return
.prompt: if yyyU\==''  then prompt=yyy;                                            return
.cmdX:   xxxF yyy;                                                                 return
/*──────────────────────────────────────────────────────────────────────────────────────*/
err:     say;   say;   say center(' error! ', max(40, linesize()%2), "*");   say
                               do j=1  for arg();  say arg(j);  say;  end;   say;  exit 13
/*──────────────────────────────────────────────────────────────────────────────────────*/
noValue: syntax: call err 'REXX program' condition('C') "error",,
                    condition('D'),'REXX source statement (line' sigl"):",sourceline(sigl)
/*──────────────────────────────────────────────────────────────────────────────────────*/
.help:   cmdsH= 'ATTRIB CHDIR CLS COPY DEL DIR ECHO EDIT FC FIND MEM MKDIR MORE PRINT',
                'REM RMDIR SET TREE TYPE VER XCOPY'  /*these have their own help via /? */

         cmds= '?|Help|MANual ATTRIButes CALendar CD|CHDIR|CHANGEDir COPY DELete|ERASE',
               'DELete|ERASE DIR ECHO EDIT FC|FILECOMPAre FIND HISTory Kedit LLL',
               'MEM MD|MKDIR|MAKEDir MORE PRINT PROMPT Quit|EXIT',
               'R4 RD|RMDIR|REMOVEDir REGINA REMark Rexx REDO SET TREE Type VER'

          say center(strip(xxx yyy),sw-1,'═');    cmds_=cmds;    yyyF=unabbrev(yyy)

          help.      = 'No help is available for the'    yyy    "command."
          help.cal   = 'shows a calendar for the current month or specified month.'
          help.kedit = 'KEDITs the file specified.'
          help.lll   = 'shows a formatted listing of files in the current directory.'
          help.prompt= 'sets the PROMPT message to the specified text.'
          help.quit  = 'quits (exits) this program.'
          help.redo  = 're-does the command # specified  (or the last command).'
          help.rexx  = 'executes the REXX program specified.'

          if yyy=='' then do j=1 while cmds_\==''
                          parse var cmds_ x cmds_
                          say left('',sw%2) changestr('|',x,"  |  ")
                          end    /*j*/
                     else select
                          when wordpos(yyyF,cmdsH)\==0 then yyyF '/?'
                          otherwise cmd?=yyyF
                          if left(help.yyyF,1)\==' ' then say yyyF ' ' help.yyyF
                                                     else say help.yyyF
                          end    /*select*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.history: say center('history', sw-1, '═');       w=length(hist#)
                         do j=1  for hist#;   say right(j,w)  '═══►'  @hist.j;   end /*j*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
prompter: if redoing  then do;  redoing=0;       z=hist#-1   /*special case, bare REDO. */
                                parse var  @hist.z  xxx  yyy
                           end
                      else do;  if prompt\==''  then do;   say;   say prompt;   end
                                parse pull xxx yyy
                           end

          xxxU=xxx;   upper xxxU;  if xxx==''  then return 1 /*No input?  Then try again*/
          yyyU=yyy;   upper yyyU;  yyyU=strip(yyyU)
          hist#=hist#+1;                                     /*bump the history counter.*/
          @hist.hist#=strip(xxx yyy)                         /*assign to history.       */
          xxxF=unAbbrev(xxx)                                 /*maybe expand abbreviation*/
          return 0
/*──────────────────────────────────────────────────────────────────────────────────────*/
.redo:      select
            when yyyU==''           then redoing=1     /*assume they want the last cmd. */
            when words(yyy)\==1     then call er 'too many args specified for' xxx
            when \datatype(yyy,'W') then call er "2nd arg isn't numeric for" xxx
            otherwise               nop
            end    /*select*/
       if redoing  then return                         /*handle with kid gloves.        */
       yyy=yyy/1                                       /*normalize it: +7 7. 1e1 007 7.0*/
       say 'Re-doing:'  @hist.yyy
       @hist.yyy
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
unabbrev: procedure;  arg ccc
                              select
                              when abbrev('ATTRIBUTES' , ccc, 6)     then return 'ATTRIB'
                              when abbrev('CALENDAR'   , ccc, 3)     then return 'CAL'
                              when abbrev('CHANGEDIR'  , ccc, 7) |,
                                     ccc=='CHDIR'                |,
                                     ccc=='CD'                       then return 'CHDIR'
                              when abbrev('CLEARSCREEN', ccc, 5)     then return 'CLS'
                              when abbrev('FILECOMPARE', ccc, 9)     then return 'FC'
                              when abbrev('DELETE'     , ccc, 3) |,
                                     ccc=='ERASE'                    then return 'DEL'
                              when abbrev('HISTORY'    , ccc, 4)     then return 'HISTORY'
                              when abbrev('HELP'       , ccc, 1) |,
                                   abbrev('MANUAL'     , ccc, 3) |,
                                     ccc=='?'                        then return 'HELP'
                              when abbrev('MAKEDIR'    , ccc, 5) |,
                                     ccc=='MKDIR'                |,
                                     ccc=='MD'                       then return 'MKDIR'
                              when abbrev('KEDIT'      , ccc, 1)     then return 'KEDIT'
                              when abbrev('QUIT'       , ccc, 1)     then return 'QUIT'
                              when abbrev('REMARK'     , ccc, 3)     then return 'REM'
                              when abbrev('REMOVEDIR'  , ccc, 7) |,
                                     ccc=='RMDIR'                |,
                                     ccc=='RD'                       then return 'RMDIR'
                              when abbrev('REXX'       , ccc, 1)     then return 'REXX'
                              when abbrev('TYPE'       , ccc, 1)     then return 'TYPE'
                              otherwise nop
                              end    /*select*/
          return ccc
