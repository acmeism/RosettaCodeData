/* Rexx */
qq = .rexxqueue~new()
address command "echo $HOSTNAME | rxqueue"
address command "hostname -f | rxqueue"
loop q_ = 1 while qq~queued() > 0
  hn = qq~pull()
  say q_~right(2)':' hn
  end q_
