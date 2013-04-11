proc yesno {message} {
  toplevel .msg
  pack [label .msg.l -text "$message\n (type Y/N)?"]
  set ::yn ""
  bind .msg <Key-y> {set ::yn "Y"}
  bind .msg <Key-n> {set ::yn "N"}
  vwait ::yn
  destroy .msg
}

yesno "Do you like programming?"
