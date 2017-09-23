/* Rexx */
address command "echo $HOSTNAME | rxqueue"
address command "hostname -f | rxqueue"
loop q_ = 1 while queued() > 0
  parse pull hn
  say q_~right(2)':' hn
  end q_
