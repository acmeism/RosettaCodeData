/*REXX pgm implements a priority queue; with insert/show/delete top task*/
n=0
task.=0 /* for the sake of task.0done.* */
say '------ inserting tasks.';     call ins_task 3 'Clear drains'
                                   call ins_task 4 'Feed cat'
                                   call ins_task 5 'Make tea'
                                   call ins_task 1 'Solve RC tasks'
                                   call ins_task 2 'Tax return'
                                   call ins_task 6 'Relax'
                                   call ins_task 6 'Enjoy'
say '------ Showing tasks.';       call show_tasks
say '------ Show and delete top task.'
todo=n  /* tasks to be done             */
do While todo>0
  Say top()
  End
exit

ins_task: procedure expose n task.
n=n+1
Parse Arg task.0pri.n task.0txt.n
Return

show_tasks: procedure expose task. n
do i=1 To n
  Say task.0pri.i task.0txt.i
  End
Return

top: procedure expose n task. todo /* get top task and mark it 'done' */
high=0
Do i=1 To n
  If task.0pri.i>high &,
     task.0done.i=0 Then Do
    j=i
    high=task.0pri.i
    End
  End
res=task.0pri.j task.0txt.j
task.0done.j=1
todo=todo-1
return res
