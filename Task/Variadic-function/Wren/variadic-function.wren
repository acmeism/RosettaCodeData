var printArgs = Fn.new { |args| args.each { |arg| System.print(arg) } }

printArgs.call(["Mary", "had", "3", "little", "lambs"])
