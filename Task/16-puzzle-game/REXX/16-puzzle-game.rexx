/*REXX pgm implements the  16  game;  displays game grid, prompts for a move, game won? */
sep= copies("─",8);  pad=left('',1+length(sep) ) /*pad=9 blanks.   SEP is used for msgs.*/
parse arg N hard seed .                          /*obtain optional arguments from the CL*/
er= '***error***'                                /*literal used to indicate an error msg*/
if    N=='' |    N==","  then    N= 4            /*Not specified?  Then use the default.*/
if hard=='' | hard==","  then hard= 2            /* "      "         "   "   "     "    */
if \isInt(N)  then do;  say sep  er  "grid size isn't an integer: "   N;    exit 1;    end
if N<2 | N>9  then do;  say sep  er  "grid size is out of range: "    N;    exit 1;    end
if isInt(seed)  then call random , , seed        /*use repeatability seed for RANDOM BIF*/
say sep 'Playing a '      N*N       " game with a difficulty level of: "     hard
#=0
         do   r=1  for N                         /* [◄]  build a solution for testing.  */
           do c=1  for N;   #= #+1;    @.r.c= #  /*bump number (count), define a cell.  */
           end   /*c*/
         end     /*r*/
                                                 /* [↓]  HARD  is the puzzle difficulty.*/
     do hard;     row= random(1)                 /*scramble the grid  HARD   # of times.*/
     if row  then call move random(1,N)substr('LR', random(1, 2), 1)   /* ◄── move row. */
             else call move substr('abcdefghi',random(1,N), 1)substr("+-",random(1,2),1)
     end   /*hard*/                                                    /* [↓]  move col.*/
                                                 /*play 16─game until  solved  or  quit.*/
   do  until done()                              /*perform moves until puzzle is solved.*/
   call move                                     /*get user's move(s)  and  validate it.*/
   if errMsg\==''  then do;  say sep er errMsg".";  iterate; end   /*possible error msg?*/
   end   /*until*/

call show;     say sep  'Congratulations!   The'      N**2"─puzzle is solved."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
done: #=0; do r=1 to N; do c=1 to N; #=#+1; if @.r.c\==# then return 0; end; end; return 1
isInt: return datatype( arg(1), 'W')             /*return 1 if arg is a whole number.   */
ghost: do r=1  for n;   do c=1  for n;    !.r.c= @.r.c;  end  /*r*/;   end  /*c*/;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
move: arg x                                      /*obtain optional move from ARG or ask.*/
      ask1= sep 'Please enter a     row  number    followed by a   L   or   R,       or'
      ask2= sep '       enter a   column letter    followed by a   +   or   -'   @quit
      @quit= '      (or Quit):'
      if x==''  then do
                     if queued()==0  then do;   say;   call show;    say ask1;    say ask2
                                          end
                     pull x;  x= space(x, 0)     /*obtain a response;  elide whitespace.*/
                     end
      y= left(x, 1);          d= right(x, 1)     /*get a number or letter, and also a ± */
      num= isInt(d);        let= datatype(y,'U') /*get direction to shift, based on type*/
      if abbrev('QUIT', x, 1)  then do;  say;  say;  say sep  "quitting.";    exit;    end
               select
               when x == ''                    then errMsg= "nothing entered"
               when length(x)>2                then errMsg= "improper response:  "       x
               when num  &  (y <1   | y >N  )  then errMsg= "row isn't in range: "       y
               when num  &  (d\="L" & d\='R')  then errMsg= "row shift isn't L or R: "   d
               when let  &  (y <"A" | y >HI )  then errMsg= "col isn't in range: "       y
               when let  &  (d\="+" & d\='-')  then errMsg= "col shift isn't + or -: "   d
               otherwise                            errMsg=
               end   /*select*/                  /* [↑]  verify the human entered data. */
      call ghost;    yn= pos(y, 'ABCDEFGHI')     /*create a ghost grid for easy moving. */
      if isInt(y)  then if d=='R'  then  do c=1  for N;  cm= c-1;  if c==1  then cm= c+N-1
                                                         @.y.c= !.y.cm
                                         end
                                   else  do c=1  for N;  cp= c+1;  if c==N  then cp= 1
                                                         @.y.c= !.y.cp
                                         end
                   else if d=='-'  then  do r=1  for N;  rm= r-1;  if r==1  then rm= r+N-1
                                                         @.r.yn= !.rm.yn
                                         end
                                   else  do r=1  for N;  rp= r+1;  if r==N  then rp= 1
                                                         @.r.yn= !.rp.yn
                                         end
      return
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: top= '╔'copies( copies("═", 2)'╦', N);           top= left( top, length(top) - 1)"╗"
      bar= '╠'copies( copies("═", 2)'╬', N);           bar= left( bar, length(bar) - 1)"╣"
      bot= '╚'copies( copies("═", 2)'╩', N);           bot= left( bot, length(bot) - 1)"╝"
      ind= left('',  3 + length(N) )                              /*compute indentation.*/
      col= ind  ind  ind' '   subword("a- b- c- d- e- f- g- h- i-",  1,  n)
      HI= substr('abcdefghi', N, 1);    upper HI
      say col  ind  ind  ind  '-  means shift a column down';            say pad  ind  top
              do    r=1  for N;   z= r'R'    "  ║"                 /*build NxN game grid*/
                 do c=1  for N;   z= z || right(@.r.c, 2)'║'       /*build  row by row. */
                 end   /*c*/
              z= z   ' '   r"L"                                    /*add right-side info*/
              if r==1  then z= z  pad'L  means shift a row left'   /* "   1st help info.*/
              if r==2  then z= z  pad'R  means shift a row right'  /* "   2nd   "    "  */
              say pad z;             if r\==N  then say pad  ind  bar
              end     /*r*/
      say pad  ind  bot;             say;
      say translate(col, '+', "-")   ind  ind  ind  "+  means shift a column up";     say
      return
