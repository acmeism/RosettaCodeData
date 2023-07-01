loop(-From=2008, -to=2121) => {^
  local(tDate = date('12/25/' + loop_count))
  #tDate->dayOfWeek == 1 ? '\r' + #tDate->format('%D') + ' is a Sunday'
^}
