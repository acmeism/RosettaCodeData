$ return  ! ignored since we haven't done a gosub yet
$
$ if p1 .eqs. "" then $ goto main
$ inner:
$ exit
$
$ main:
$ goto label  ! if label hasn't been read yet then DCL will read forward to find label
$ label:
$ write sys$output "after first occurrence of label"
$
$ on control_y then $ goto continue1  ! we will use this to get out of the loop that's coming up
$
$ label:  ! duplicate labels *are* allowed, the most recently read is the one that will be the target
$  write sys$output "after second occurrence of label"
$  wait 0::2  ! since we are in a loop this will slow things down
$  goto label  ! hit ctrl-y to break out
$
$ continue1:  ! the previous "on control_y" remains in force despite having been triggered
$
$ label = "jump"
$ goto 'label  ! target can be a variable; talk about handy
$ jump:
$ write sys$output "after first occurrence of jump"
$
$ first_time = "true"
$ continue_label = "continue2"
$ 'continue_label:  ! even the label can be a variable (but only backwards); talk about handy
$ if first_time then $ goto skip
$ break = "true"
$ return
$
$ skip:
$ first_time = "false"
$
$ on control_y then $ gosub 'continue_label  ! setup a new on control_y to get out the next loop coming up
$
$ break = "false"
$ 'label:
$  write sys$output "after second occurrence of jump"
$  wait 0::2
$  if .not. break then $ goto 'label
$
$ gosub sub1  ! no new scope or parameters
$ label = "sub1"
$ gosub 'label
$
$ call sub4 a1 b2 c3  ! new scope and parameters
$
$ @nl:  ! new scope and parameters in another file but same process
$
$ procedure_filename = f$environment( "procedure " )  ! what is our own filename?
$ @'procedure_filename inner
$
$ exit  ! exiting outermost scope exits the command procedure altogether, i.e. back to shell
$
$ sub1:
$ return
$
$ sub2:
$ goto break  ! structurally disorganized but allowed
$
$ sub3:
$ return
$
$ break:
$ return
$
$ sub4: subroutine
$ exit
$ endsubroutine
