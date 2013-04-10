/*REXX pgm: Dinesman's multiple-dwelling problem with "natural" wording.*/
names= 'Baker Cooper Fletcher Miller Smith'      /*names of the tenants.*/
floors=5;     top=floors;     bottom=1;      #=floors;         sols=0
                                       /*floor 1 is the ground floor.   */
     do !.1=1 for #;do !.2=1 for #;do !.3=1 for #;do !.4=1 for #;do !.5=1 for #
       do p=1 for words(names); _=word(names,p); upper _; call value _,!.p
       end   /*p*/
                                       /*  [↓] don't live on same floor.*/
      do j=1 for #-1; do k=j+1 to #; if !.j==!.k then iterate !.5; end;end

     call Waldo  /* ◄───────────────────where the rubber meets the road.*/
     end /*!.5*/;    end /*!.4*/;    end /*!.3*/;    end /*!.2*/;   end /*!.1*/

say;        say  'found'  sols  "solution"s(sols)'.'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────Waldo subroutine────────────────────*/
Waldo:
         if Baker    == top                                    then return
         if Cooper   == bottom                                 then return
         if Fletcher == bottom      |  Fletcher == top         then return
         if Miller   <= Cooper                                 then return
         if Smith    == Fletcher-1  |  Smith    == Fletcher+1  then return
         if Fletcher == Cooper-1    |  Fletcher == Cooper+1    then return

say;  sols=sols+1                      /*list tenants in order in list. */
                      do p=1  for words(names);        _=word(names,p)
                      say right(_,20) 'lives on the' !.p||th(!.p) "floor."
                      end   /*p*/
return
/*──────────────────────────────────one-liner subroutines───────────────*/
s: if arg(1)=1 then return ''; return 's'   /*a simple pluralizer funct.*/
th:procedure;parse arg x;x=abs(x);return  word('th st nd rd',1+x//10*(x//100%10\==1)*(x//10<4))
