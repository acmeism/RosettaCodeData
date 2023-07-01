var s = "rosetta code phrase reversal"
System.print("Input               : %(s)")
System.print("String reversed     : %(s[-1..0])")
System.print("Each word reversed  : %(s.split(" ").map { |w| w[-1..0] }.join(" "))")
System.print("Word order reversed : %(s.split(" ")[-1..0].join(" "))")
