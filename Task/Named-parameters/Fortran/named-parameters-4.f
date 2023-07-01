call b_sub(1)              ! error: missing non optional arg2
call b_sub(arg2=1)         ! ok
call b_sub(1, 2)           ! ok: arg1 is 1, arg2 is 2
call b_sub(arg2=2, arg1=1) ! the same as the previous line
