/*REXX program demonstrates one method to parse options for a command (entered on the CL*/
parse arg opts                                   /*this preserves the case of  options. */
opts=space(opts)                                 /*elide superfluous blanks in options. */
!.=                                              /*all options to be  "null"  (default).*/
   do  while opts\==''                           /*keep parsing 'til all  opts  examined*/
   parse var opts x opts                         /*obtain a single keyword from options.*/

     select                                      /*hard-coded WHENs for option detection*/
     when x=='-e'   then parse var opts !.e_                                          opts
     when x=='-p'   then parse var opts !.p_                                          opts
     when x=='-n'   then !.z_=1
     when x=='-u'   then parse var opts !.uname_ !.unnn_                              opts
     when x=='-ul'  then parse var opts !.ul_                                         opts
     when x=='-vzu' then parse var opts !.vzu_   !.vzurange                           opts
     when x=='-w'   then parse var opts !.wStart_ !.waddr_ !.wrange_1 '-' !.wrange_2  opts
     when x=='-z'   then !.=1
     otherwise call sayer 'option  '      x      " isn't a known option."
     end     /*select*/
  end        /*do while*/

                                   /*check for conflicts here and/or validity of values.*/

if !.z_==1 & !.n_==1  then call sayer  "N  and  Z  can't both be specified."

if !.wrange_1\==''  then do                     /*see if it's a whole number (integer). */
                         if \isInt(!.wrange1_)  then call sayer "wRange isn't an integer."
                         yada yada yada
                          .
                          .
                          .
                         end

               ...stuff...
          ...more stuff...
...and still more stuff...
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
isInt:   return  datatype(arg(1), 'W')           /*return  1  if  argument is an integer*/
isNum:   return  datatype(arg(1), 'N')           /*return  1  if  argument is a  number.*/
sayer:   say;      say '***error***'  arg(1);      exit 13
