/*REXX program demonstrates (with displays) a method of parametric polymorphism in REXX.*/
call newRoot  1.00, 3                            /*new root,  and also indicate 3 stems.*/
                                                 /* [↓]  no need to label the stems.    */
call addStem  1.10                               /*a new stem  and  its initial value.  */
call addStem  1.11                               /*"  "    "    "    "     "      "     */
call addStem  1.12                               /*"  "    "    "    "     "      "     */
call addStem  1.20                               /*"  "    "    "    "     "      "     */
call addStem  1.21                               /*"  "    "    "    "     "      "     */
call addStem  1.22                               /*"  "    "    "    "     "      "     */
                       call sayNodes             /*display some nicely formatted values.*/
call modRoot  50                                 /*modRoot will add fifty to all stems. */
                       call sayNodes             /*display some nicely formatted values.*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
addStem:  nodes=nodes+1;       do j=1  for stems;  root.nodes.j=arg(1);  end;       return
/*──────────────────────────────────────────────────────────────────────────────────────*/
modRoot:         do    j=1  for nodes            /*traipse through all the defined nodes*/
                    do k=1  for stems
                    if datatype(root.j.k, 'N')  then root.j.k=root.j.k + arg(1)  /*bias.*/
                    end   /*k*/                  /* [↑]  only add if numeric stem value.*/
                 end      /*j*/
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
newRoot:  stems=arg(2);     nodes= -1            /*set  NODES  to a kind of  "null".    */
          call addStem copies('═', 9);        call addStem arg(1)
          return
/*──────────────────────────────────────────────────────────────────────────────────────*/
sayNodes: say;     do    j=0  to nodes;   _=     /*ensure each of the nodes gets shown. */
                      do k=1  for stems;  _=_ right(root.j.k, 9)
                      end   /*k*/
                   say substr(_, 2)              /*ignore the first (leading) blank.    */
                   end      /*j*/

          say left('', stems*11)  ||  '('nodes" nodes)"     /*also show number of nodes.*/
          return
