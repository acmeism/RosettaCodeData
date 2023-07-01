/* Execute a system command and retrieve its output into a stem. */
  trace normal

/* Make the default values for the stem null strings. */
  text. = ''

/* Issue the system command.  "address command" is optional.) */
  address command 'ls -l | rxqueue'

/* Remember the return code from the command. */
  ls_rc = rc

/* Remember the number of lines created by the command. */
  text.0 = queued()

/* Fetch each line into a stem variable. */
  do t = 1 to text.0
    parse pull text.t
  end

/* Output each line in reverse order. */
  do t = text.0 to 1 by -1
    say text.t
  end

/* Exit with the system command's return code. */
exit ls_rc
