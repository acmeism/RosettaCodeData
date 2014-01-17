/*REXX program demonstrates a method of parametric polymorphism in REXX.*/
call newRoot  1.00, 3                  /*new root and indicate 3 stems. */
                                       /* [↓] no need to label the stems*/
call addStem  1.10                     /*new stem and its initial value.*/
call addStem  1.11                     /* "    "   "   "     "      "   */
call addStem  1.12                     /* "    "   "   "     "      "   */
call addStem  1.20                     /* "    "   "   "     "      "   */
call addStem  1.21                     /* "    "   "   "     "      "   */
call addStem  1.22                     /* "    "   "   "     "      "   */
call sayNodes                          /*display nicely formatted values*/
call modRoot  50                       /*MOD will add 50 to all stems.  */
call sayNodes                          /*display nicely formatted values*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MODROOT─────────────────────────────*/
modRoot:       do j=1  for nodes       /*traipse through all the nodes. */
                  do k=1  for stems;     _=root.j.k;     ?=datatype(_,'N')
                  if ?  then root.j.k=_+arg(1)   /*can stem be added to?*/
                  end   /*k*/          /* [↑]  only add if it's numeric.*/
               end      /*j*/
return
/*──────────────────────────────────NEWROOT─────────────────────────────*/
newRoot: stems=arg(2);  nodes=-1;      /*set NODES to a kind of "null". */
call addStem copies('─',9);              call addStem arg(1)
return
/*──────────────────────────────────SAYNODES────────────────────────────*/
sayNodes: say;     do j=0  to nodes;      _=      /*each node gets shown*/
                      do k=1  for stems;  _=_ right(root.j.k,9); end /*k*/
                   say substr(_,2)                /*ignore the 1st blank*/
                   end      /*j*/

say left('', stems*9+stems) || '('nodes" nodes)"  /*also show # of nodes*/
return
/*──────────────────────────────────ADDSTEM─────────────────────────────*/
addStem: nodes=nodes+1;  do j=1 for stems;  root.nodes.j=arg(1); end /*j*/
return
