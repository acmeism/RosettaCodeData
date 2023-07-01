/*REXX program  simulates  the  execution  of a   One─Instruction Set Computer  (OISC). */
signal on halt                                   /*enable user to  halt  the simulation.*/
parse arg $                                      /*get optional low memory vals from CL.*/
$$= '15 17 -1 17 -1 -1 16 1 -1 16 3 -1 15 15 0 0 -1'  /*common stuff for EBCDIC & ASCII.*/
    /*EBCDIC "then" choice [↓]       H   e   l   l   o  , BLANK w   o   r   l   d  !  LF*/
if $='' then if 6=="f6"x  then $=$$ 200 133 147 147 150 107 64 166 150 153 147 132 90 21 0
                          else $=$$  72 101 108 108 111  44 32 119 111 114 108 100 33 10 0
                        /* [↑]  ASCII   (the "else" choice).                Line Feed≡LF*/
@.= 0                                            /*zero all memory & instruction pointer*/
         do j=0  for words($);  @.j=word($,j+1)  /*assign memory.  OISC is zero─indexed.*/
         end   /*j*/                             /*obtain A, B, C memory values──►────┐ */
    do #=0  by 3 until #<0;     a= @(#-3);    b= @(#-2);     c= @(#-1)   /* ◄─────────┘ */
        select                                   /*choose an instruction state.         */
        when a<0  then @.b= charin()             /*  read a character from the terminal.*/
        when b<0  then call charout , d2c(@.a)   /* write "     "      to   "     "     */
        otherwise      @.b= @.b - @.a            /*put difference  ────►  location  B.  */
                    if @.b<=0  then #= c         /*Not positive?   Then set  #  to  C.  */
        end   /*select*/                         /* [↑]  choose one of two states.      */
    end       /*#*/                              /*leave the DO loop if  #  is negative.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
@:     parse arg @z;    return @.@z              /*return  a  memory location (cell @Z).*/
halt:  say 'The One─Instruction Set Computer simulation pgm was halted by user.';   exit 1
