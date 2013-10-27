/*REXX program converts temperature for:  C, D, F, N, Ra, Re, Ro, and K.*/
parse arg tList                        /*get specified temperature lists*/

  do  until  tList=''                  /*process a list of temperatures.*/
  parse  var tList  x  ','  tList      /*temps are separated by commas. */
  x=translate(x,'((',"[{")             /*support other grouping symbols.*/
  x=space(x);  parse var x z '('       /*handle any comments (if any).  */
  if z==''     then call serr 'no arguments were specified.'
  _=verify(z, '+-.0123456789')         /*a list of valid number thingys.*/
  n=z
  if _\==0  then do
                 if _==1  then call serr 'illegal temperature:'  z
                 n=left(z, _-1)        /*pick off the number (hopefully)*/
                 u=strip(substr(z, _)) /*pick off the temperature unit. */
                 end
            else u='k'                 /*assume  Kelvin as per task req.*/

  uU=translate(u,'eE',"éÉ");  upper uU /*uppercase version of temp unit.*/
  if left(uU,7)=='DEGREES' then uU=substr(uU,8)  /*redundant "degrees"? */
  if left(uU,6)=='DEGREE'  then uU=substr(uU,7)  /*   "      "degree" ? */
  uU=strip(uU)
  if \datatype(n,'N')  then call serr 'illegal number:' n
                                       /*accept alternate spellings.    */
      select                           /*convert ──►  ºF  temperatures. */
      when abbrev('CENTIGRADE' , uU)    |,
           abbrev('CENTRIGRADE', uU)    |,            /* 50% misspelled.*/
           abbrev('CETIGRADE'  , uU)    |,            /* 50% misspelled.*/
           abbrev('CENTINGRADE', uU)    |,
           abbrev('CENTESIMAL' , uU)    |,
           abbrev('CELCIUS'    , uU)    |,            /* 82% misspelled.*/
           abbrev('CELCIOUS'   , uU)    |,            /*  4% misspelled.*/
           abbrev('CELCUIS'    , uU)    |,            /*  4% misspelled.*/
           abbrev('CELSUIS'    , uU)    |,            /*  2% misspelled.*/
           abbrev('CELCEUS'    , uU)    |,            /*  2% misspelled.*/
           abbrev('CELCUS'     , uU)    |,            /*  2% misspelled.*/
           abbrev('CELISUS'    , uU)    |,            /*  1% misspelled.*/
           abbrev('CELSUS'     , uU)    |,            /*  1% misspelled.*/
           abbrev('CELSIUS'    , uU)       then F=n       *  9/5   +  32

      when abbrev('DELISLE'    , uU)       then F=212 -(n *  6/5)

      when abbrev('FARENHEIT'  , uU)    |,            /* 39% misspelled.*/
           abbrev('FARENHEIGHT', uU)    |,            /* 15% misspelled.*/
           abbrev('FARENHITE'  , uU)    |,            /*  6% misspelled.*/
           abbrev('FARENHIET'  , uU)    |,            /*  3% misspelled.*/
           abbrev('FARHENHEIT' , uU)    |,            /*  3% misspelled.*/
           abbrev('FARINHEIGHT', uU)    |,            /*  2% misspelled.*/
           abbrev('FARENHIGHT' , uU)    |,            /*  2% misspelled.*/
           abbrev('FAHRENHIET' , uU)    |,            /*  2% misspelled.*/
           abbrev('FERENHEIGHT', uU)    |,            /*  2% misspelled.*/
           abbrev('FEHRENHEIT' , uU)    |,            /*  2% misspelled.*/
           abbrev('FERENHEIT'  , uU)    |,            /*  2% misspelled.*/
           abbrev('FERINHEIGHT', uU)    |,            /*  1% misspelled.*/
           abbrev('FARIENHEIT' , uU)    |,            /*  1% misspelled.*/
           abbrev('FARINHEIT'  , uU)    |,            /*  1% misspelled.*/
           abbrev('FARANHITE'  , uU)    |,            /*  1% misspelled.*/
           abbrev('FAHRENHEIT' , uU)      then F=n

      when abbrev('KELVINS'    , uU)    |,            /* 46% misspelled.*/
           abbrev('KALVIN'     , uU)    |,            /* 27% misspelled.*/
           abbrev('KERLIN'     , uU)    |,            /* 18% misspelled.*/
           abbrev('KEVEN'      , uU)    |,            /*  9% misspelled.*/
           abbrev('KELVIN'     , uU)      then F=n       *  9/5   - 459.67

      when abbrev('NEUTON'     , uU)    |,            /*100% misspelled.*/
           abbrev('NEWTON'     , uU)      then F=n       * 60/11  +  32

                                     /*a single  R  is taken as Rankine.*/
      when abbrev('RANKINE'    , uU)      then F=n                - 459.67

      when abbrev('REAUMUR'    , uU, 2)   then F=n       *  9/4   +  32

      when abbrev('ROEMER'     , uU, 2) |,
           abbrev('ROMER'      , uU, 2)   then F=(n-7.5) * 27/4   +  32
      otherwise           call serr  'illegal temperature scale:'  u
      end   /*select*/

  say right(' ' x,55,"─")              /*show original value&scale, sep.*/
  say Tform( ( F   - 32     )   *  5/9           )    'Celsius'
  say Tform( ( 212 - F      )   *  5/6           )    'Delisle'
  say Tform(   F                                 )    'Fahrenheit'
  say Tform( ( F   + 459.67 )   *  5/9           )    'Kelvin'
  say Tform( ( F   - 32     )   *  11/60         )    'Newton'
  say Tform(   F   + 459.67                      )    'Rankine'
  say Tform( ( F   - 32     )   *  4/9           )    'Reaumur'
  say Tform( ( F   - 32     )   *  7/24    + 7.5 )    'Romer'
  end   /*until tlist='' */

exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TFORM subroutine────────────────────*/
Tform: procedure;  showDig=8           /*only show 8 significant digits.*/
_=format(arg(1),,showDig)/1            /*format arg 8 digs past the  .  */
p=pos('.',_)                           /*find position of decimal point.*/
                                       /* [↓] align integers with FP #s.*/
if p==0  then _=_ || left('',showDig+1)             /*no  decimal point.*/
         else _=_ || left('',showDig-length(_)+p)   /*has    "      "   */
return right(_,20)                     /*return the re-formatted arg.   */
/*──────────────────────────────────SERR subroutine─────────────────────*/
serr: say;   say '***error!***';    say;    say arg(1);    say;    exit 13
