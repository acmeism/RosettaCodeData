var removeVowels = Fn.new { |s| s.where { |c| !"aeiouAEIOU".contains(c) }.join() }

var s = "Wren Programming Language"
System.print("Input  : %(s)")
System.print("Output : %(removeVowels.call(s))")
