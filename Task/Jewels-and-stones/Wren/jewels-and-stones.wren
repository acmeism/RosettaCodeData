var countJewels = Fn.new { |s, j| s.count { |c| j.contains(c) } }

System.print(countJewels.call("aAAbbbb", "aA"))
System.print(countJewels.call("ZZ", "z"))
