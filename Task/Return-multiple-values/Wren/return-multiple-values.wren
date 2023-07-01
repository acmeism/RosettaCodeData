var splitName = Fn.new { |fullName| fullName.split(" ") }

var names = splitName.call("George Bernard Shaw")
System.print("First name: %(names[0]), middle name: %(names[1]) and surname: %(names[2]).")
