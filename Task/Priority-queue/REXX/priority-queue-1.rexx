/*REXX program implements a  priority queue   with  insert/display/delete  the top task.*/
#=0;   @.=                                       /*0 tasks;  nullify the priority queue.*/
say '══════ inserting tasks.';     call .ins  3  "Clear drains"
                                   call .ins  4  "Feed cat"
                                   call .ins  5  "Make tea"
                                   call .ins  1  "Solve RC tasks"
                                   call .ins  2  "Tax return"
                                   call .ins  6  "Relax"
                                   call .ins  6  "Enjoy"
say '══════ showing tasks.';       call .show
say '══════ deletes top task.';    say .del()    /*delete the top task.                 */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
.del:  procedure expose @. #; arg p;  if p=''  then p=.top();    y=@.p;   @.p=;   return y
.ins:  procedure expose @. #; #=#+1;  @.#=arg(1);    return #          /*entry, P, task.*/
.show: procedure expose @. #; do j=1  for #;  _=@.j;  if _\==''  then say _;  end;  return
/*──────────────────────────────────────────────────────────────────────────────────────*/
.top:  procedure expose @. #;      top=;              top#=
                   do j=1  for #;  _=word(@.j, 1);    if _==''  then iterate
                   if top=='' | _>top  then do;    top=_;    top#=j;    end
                   end   /*j*/
       return top#
