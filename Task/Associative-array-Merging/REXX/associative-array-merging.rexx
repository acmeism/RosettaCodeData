/*REXX program merges two associative arrays  (requiring an external list of indices).  */
$.=                                              /*define default value(s) for arrays.  */
@.wAAn= 21;      @.wKey= 7;       @.wVal= 7      /*max widths of:  AAname, keys, values.*/
call defAA  'base',     "name Rocket Skates",   'price 12.75',   "color yellow"
call defAA  'update',   "price 15.25",          "color red",     'year 1974'
call show   'base'
call show   'update'
call show   'new'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
defAA: procedure expose $. @.;  parse arg AAn;      new= 'new'   /*get AA name; set NEW.*/
         do j=2  to arg();   parse value arg(j)  with  key val   /*obtain key and value.*/
         $.AAn.key= val                          /*assign a  value  to a  key for AAn.  */
         if wordpos(key, $.AAN.?keys)==0  then $.AAn.?keys= $.AAn.?keys key
                                                 /* [↑]  add to key list if not in list.*/
         $.new.key= val                          /*assign a  value  to a  key for "new".*/
         if wordpos(key, $.new.?keys)==0  then $.new.?keys= $.new.?keys key
                                                 /* [↑]  add to key list if not in list.*/
         @.wKey= max(@.wKey, length(key) )       /*find max width of a name of a  key.  */
         @.wVal= max(@.wVal, length(val) )       /*  "   "    "    " "   "   " "  value.*/
         @.wAA = max(@.wAAn, length(AAn) )       /*  "   "    "    " "   "   "    array.*/
         end   /*j*/
       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show:  procedure expose $. @.;  parse arg AAn;      say;     _= '═'    /*set title char.*/
         do j=1  for words($.AAn.?keys)                                /*process keys.  */
         if j==1  then say  center('associate array', @.wAAn,     _)  ,
                            center("key"            , @.wKey,     _)  ,
                            center('value'          , @.wVal + 2, _)
         key= word($.AAn.?keys, j)                              /*get the name of a key.*/
         say center(AAn, @.wAAn)  right(key, @.wKey)  $.AAn.key /*show some information.*/
         end   /*j*/
       return
