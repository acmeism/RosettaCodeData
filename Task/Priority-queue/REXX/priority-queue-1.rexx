/*REXX pgm implements a priority queue; with insert/show/delete top task*/
numeric digits 100;  #=0;  @.=     /*big #, 0 tasks, null priority queue*/
say '══════ inserting tasks.';     call .ins  3  'Clear drains'
                                   call .ins  4  'Feed cat'
                                   call .ins  5  'Make tea'
                                   call .ins  1  'Solve RC tasks'
                                   call .ins  2  'Tax return'
                                   call .ins  6  'Relax'
                                   call .ins  6  'Enjoy'
say '══════ showing tasks.';       call .show
say '══════ deletes top task.';        do #         /*number of tasks.  */
                                       say .del()   /*delete top task.  */
                                       end          /* [↑] do top first.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────.INS subroutine─────────────────────*/
.ins: procedure expose @. #; #=#+1; @.#=arg(1); return # /*entry,P,task.*/
/*──────────────────────────────────.DEL subroutine─────────────────────*/
.del: procedure expose @. #;  parse arg p;      if p==''  then p=.top()
x=@.p;  @.p=                           /*delete the top task entry.     */
return x                               /*return task that was deleted.  */
/*──────────────────────────────────.SHOW subroutine────────────────────*/
.show: procedure expose @. #
                 do j=1  for #;  _=@.j;  if _=='' then iterate;      say _
                 end   /*j*/           /* [↑] show whole list or just 1.*/
return
/*──────────────────────────────────.TOP subroutine─────────────────────*/
.top: procedure expose @. #;  top=;  top#=
                  do j=1  for #;  _=word(@.j,1);  if _==''  then iterate
                  if top=='' | _>top  then do; top=_; top#=j; end
                  end   /*j*/
return top#
