def list := [def x := timer.now(), x]    # two copies of the current time
list[0] == x                             # x is still visible here; returns true
