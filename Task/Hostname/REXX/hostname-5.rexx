/* Rexx */
address command "hostname -f" with output stem hn.
do q_ = 1 to hn.0
  say hn.q_
  end q_
exit
