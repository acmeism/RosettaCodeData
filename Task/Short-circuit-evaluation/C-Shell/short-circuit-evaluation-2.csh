# Succeeds, only prints "ok".
if ( 1 || { echo This command never runs. } ) echo ok

# Fails, aborts shell with "bad: Undefined variable".
if ( 1 || $bad ) echo ok

# Prints "error", then "ok".
if ( 1 || `echo error >/dev/stderr` ) echo ok
