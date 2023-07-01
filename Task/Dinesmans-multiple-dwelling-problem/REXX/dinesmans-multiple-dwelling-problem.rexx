/*REXX program solves the  Dinesman's multiple─dwelling  problem with "natural" wording.*/
names= 'Baker Cooper Fletcher Miller Smith'      /*names of multiple─dwelling tenants.  */
#tenants= words(names)                           /*the number of tenants in the building*/
floors= 5;              top= floors;   bottom= 1 /*floor 1 is the ground (bottom) floor.*/
#= 0                                             /*the number of solutions found so far.*/
     do         @.1=1  for floors                /*iterate through all floors for rules.*/
       do       @.2=1  for floors                /*   "       "     "     "    "    "   */
         do     @.3=1  for floors                /*   "       "     "     "    "    "   */
           do   @.4=1  for floors                /*   "       "     "     "    "    "   */
             do @.5=1  for floors                /*   "       "     "     "    "    "   */
             call set
               do    j=1   for floors-1;  a= @.j /* [↓]  people don't live on same floor*/
                  do k=j+1  to floors            /*see if any people live on same floor.*/
                  if a==@.k  then iterate @.5    /*Is anyone cohabiting?  Then not valid*/
                  end   /*k*/
               end      /*j*/
             call Waldo                          /* ◄══ where the rubber meets the road.*/
             end        /*@.5*/
           end          /*@.4*/
         end            /*@.3*/
       end              /*@.2*/
     end                /*@.1*/

say 'found '     #       " solution"s(#).        /*display the number of solutions found*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
set:      do p=1  for #tenants;   call value word(names, p), @.p;   end;       return
s:     if arg(1)=1  then return '';    return "s"        /*a simple pluralizer function.*/
th:    arg x;  x=abs(x);  return word('th st nd rd', 1 +x// 10* (x//100%10\==1)*(x//10<4))
/*──────────────────────────────────────────────────────────────────────────────────────*/
Waldo: if Baker    == top                                          then return
       if Cooper   == bottom                                       then return
       if Fletcher == bottom         |   Fletcher == top           then return
       if Miller   \> Cooper                                       then return
       if Smith    == Fletcher - 1   |   Smith    == Fletcher + 1  then return
       if Fletcher == Cooper   - 1   |   Fletcher == Cooper   + 1  then return
       #= # + 1                                  /* [↑]  "|"  is REXX's "or" comparator.*/
       say;           do p=1  for #tenants;             tenant= word(names, p)
                      say right(tenant, 35)  'lives on the'     @.p || th(@.p)    "floor."
                      end   /*p*/                /* [↑]  "||"  is REXX's concatenation. */
       return                                    /* [↑]  show tenants in order in NAMES.*/
