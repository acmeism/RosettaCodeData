/*REXX program solves the  Dinesman's multiple─dwelling  problem with "natural" wording.*/
names= 'Baker Cooper Fletcher Miller Smith'      /*names of multiple─dwelling tenants.  */
tenants=words(names)                             /*the number of tenants in the building*/
floors=5;   top=floors;    bottom=1;   #=floors; /*floor 1 is the ground (bottom) floor.*/
sols=0
        do !.1=1 for #;  do !.2=1 for #;  do !.3=1 for #;  do !.4=1 for #;  do !.5=1 for #
          do p=1 for tenants;     _=word(names,p);         upper _;      call value _, !.p
          end   /*p*/
                         do     j=1   for #-1    /* [↓]  people don't live on same floor*/
                             do k=j+1  to #;   if !.j==!.k  then iterate !.5    /*cohab?*/
                             end   /*k*/
                         end       /*j*/
        call Waldo                               /* ◄══ where the rubber meets the road.*/
        end;  end;  end;  end;  end              /*!.5  &  !.4  &  !.3   &  !.2  &   !.1*/

say 'found'    sols     "solution"s(sols).       /*display the number of solutions found*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Waldo: if Baker    == top                                     then return
       if Cooper   == bottom                                  then return
       if Fletcher == bottom      |  Fletcher == top          then return
       if Miller   \> Cooper                                  then return
       if Smith    == Fletcher-1  |  Smith    == Fletcher+1   then return
       if Fletcher == Cooper  -1  |  Fletcher == Cooper  +1   then return
       sols=sols+1
       say;              do p=1  for tenants;           tenant=right( word(names, p),  30)
                         say tenant      'lives on the'      !.p || th(!.p)       "floor."
                         end   /*p*/
       return                                    /* [↑]  show tenants in order in NAMES.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:     if arg(1)=1  then return '';    return "s"        /*a simple pluralizer function.*/
th:    arg x;  x=abs(x);  return word('th st nd rd', 1 +x// 10* (x//100%10\==1)*(x//10<4))
