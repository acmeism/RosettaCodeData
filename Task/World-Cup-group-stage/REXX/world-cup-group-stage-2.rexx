/*REXX pgm calculates world cup standings based on the number of games won by the teams.*/
parse arg teams win .                            /*obtain optional argument from the CL.*/
if teams=='' | teams==","  then teams= 4         /*Not specified?  Then use the default.*/
if   win=='' |   win==","  then   win= 3         /* "      "         "   "   "     "    */
sets= 0;                           gs=           /*the number of sets  (so far).        */
         do   j=1   for teams
           do k=j+1  to teams;   sets= sets + 1  /*bump the number of game sets.        */
           games.sets= j || k;   gs= gs  j || k  /*generate the game combinations.      */
           end   /*j*/
         end     /*k*/
z= 1;                  setLimit= copies(2, sets) /*Z:   max length of any number shown. */
say teams  ' teams, '  sets   " game sets: "  gs /*display what's being used for calcs. */
results = copies(0, sets);                 say   /*start with left-most teams all losing*/
points. = 0                                      /*zero all the team's point.           */
            do until \nextResult(results);       @.= 0
              do j=1  for sets;                  r= substr( results, j, 1)
              parse var  games.j    A  +1  B                  /*get the  A  and  B teams*/
              if r==0  then      @.B= @.B + win               /*win for right─most team.*/
              if r==1  then do;  @.A= @.A + 1;  @.B= @.B + 1; end  /*draw for both teams*/
              if r==2  then      @.A= @.A + win               /*win for left─most team. */
              end       /*j*/
            call sort teams
                        do  t=1  for teams;  tm= t - 1;                             _= @.t
                        points.tm._ = points.tm._ + 1;  z= max(z, length( points.tm._) )
                        end   /*t*/
            end               /*until*/
$.=
    do j=0  for teams+6;  do k=0  for teams;   $.k= $.k || right( points.k.j, z)'│ ';  end
    end   /*j*/
say                                                  /* [↓]  build grid line for the box*/
L= length($.1) -2;     $$= translate( translate( left($.1, L), , 0123456789),   '─', " ")
say left('', 15)       center("points", L)           /*display the boxed title.         */
say left('', 15)  "╔"translate($$, '═╤', "─│")'╗'    /*display the bottom sep for title.*/
p= 0
     do m=teams-1  by -1  for teams;   p = p + 1     /*bump the  place  holder (counter)*/
                  say right('('th(p) "place)", 14)  " ║"left($.m, L)'║'
     if m>0  then say right('               ', 14)  " ╟"translate($$, '┼', "│")'╢'
     end   /*m*/
say left('', 15)  "╚"translate( $$, '═╧', "─│")'╝'   /*display the bottom sep for title.*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
nextResult: if results==setLimit  then return 0  /* [↓]  do arithmetic in base three.   */
            res= 0;      do k=1  for sets;      res= res * 3    +   substr( results, k, 1)
                         end   /*k*/
            results=;                           res= res + 1
                         do sets;      results= res // 3   ||   results;      res= res % 3
                         end   /*sets*/;                    return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
sort: procedure expose @.; arg #;  do   j=1   for #-1  /*a bubble sort, ascending order.*/
                                     do k=j+1  to #    /*swap two elements out of order.*/
                                     if @.k<@.j  then parse value  @.j @.k  with  @.k @.j
                                     end   /*k*/
                                   end     /*j*/;           return
/*──────────────────────────────────────────────────────────────────────────────────────*/
th: arg th; return (th/1) || word('th st nd rd', 1 +(th//10) *(th//100%10\==1)*(th//10<4))
